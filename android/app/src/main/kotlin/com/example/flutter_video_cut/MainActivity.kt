package com.example.flutter_video_cut

import android.Manifest
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import use_cases.*
import java.io.File
import java.io.IOException

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {

        if (intent.getIntExtra("org.chromium.chrome.extra.TASK_ID", -1) == this.taskId) {
            this.finish()
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val hasWritePermission = checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            val hasReadPermission = checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)

            val permissions = ArrayList<String>()
            if (hasWritePermission != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            }

            if (hasReadPermission != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.READ_EXTERNAL_STORAGE)
            }

            if (permissions.isNotEmpty()) {
                requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE), 102)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.flutter_video_cut.path")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "shareFiles" -> {
                        val paths = call.arguments<ArrayList<String>>()!!
                        callShareFilesHandler(paths)
                    }
                    "getThumbnail" -> {
                        val path = call.arguments<String>()!!
                        callGetThumbnail(path, result)
                    }
                    "openUrl" -> {
                        val url = call.arguments<String>()!!
                        callOpenUrl(url, result)
                    }
                    "saveInDCIM" -> {
                        val path = call.arguments<String>()
                        callSaveInDCIM(path!!, result)
                    }
                    "getVersion" -> {
                        getVersionName(result)
                    }
                    "getCacheDirectory" -> {
                        val path = cacheDir.path
                        result.success(path)
                    }
                }
            }
    }

    private fun callShareFilesHandler(paths : ArrayList<String>) {
        val uris = java.util.ArrayList<Uri>()
        for (path in paths) {
            val uri = GetUriFromPath().execute(context, path)
            uris.add(uri)
        }

        val intent = Intent()
        intent.type = "video/*"
        intent.action = Intent.ACTION_SEND_MULTIPLE
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        intent.putExtra(Intent.EXTRA_STREAM, uris)
        startActivity(intent)
    }

    private fun callGetThumbnail(path: String, result: MethodChannel.Result) {
        val bitmap: Bitmap

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val file = File(path)
            val size = GetDimensionsOfVideo().execute(path)
            bitmap = ThumbnailUtils.createVideoThumbnail(file, size, null)
        } else {
            @Suppress("DEPRECATION")
            bitmap = ThumbnailUtils.createVideoThumbnail(path, MediaStore.Images.Thumbnails.FULL_SCREEN_KIND)!!
        }

        val byteArray = ConvertBitmapToByteArray().execute(bitmap)
        result.success(byteArray)
    }

    private fun callOpenUrl(url: String, result: MethodChannel.Result) {
        try {
            val uri = Uri.parse(url)
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = uri
            startActivity(intent)

            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }

    private fun callSaveInDCIM(path: String, result: MethodChannel.Result) {
        val resolver = context.contentResolver

        val uri: Uri = GetUriFromPath().execute(context, path)
        val mimeType = resolver.getType(uri)

        val fileName = GetFileName().execute(resolver, uri)
        val fileNameWithoutExtension = fileName.split(".")[0]

        val uriSaved: Uri?
        val contentValues: ContentValues
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            contentValues = ContentValues().apply {
                put(MediaStore.Video.Media.TITLE, fileName)
                put(MediaStore.Video.Media.DISPLAY_NAME, fileNameWithoutExtension)
                put(MediaStore.Video.Media.RELATIVE_PATH, Environment.DIRECTORY_DCIM + "/Video Cut")
                put(MediaStore.Video.Media.MIME_TYPE, mimeType)
                put(MediaStore.Video.Media.DATE_ADDED, System.currentTimeMillis() / 1000)
            }

            val collection = MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            uriSaved = resolver.insert(collection, contentValues)
        } else {
            val directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).absolutePath + "/Video Cut"
            File("$directory/").mkdirs()

            val createdVideo = File(directory, fileName)
            contentValues = ContentValues().apply {
                put(MediaStore.Video.Media.TITLE, fileName)
                put(MediaStore.Video.Media.DISPLAY_NAME, fileName)
                put(MediaStore.Video.Media.MIME_TYPE, mimeType)
                put(MediaStore.Video.Media.DATE_ADDED, System.currentTimeMillis() / 1000)
                put(MediaStore.Video.Media.DATA, createdVideo.absolutePath)
            }

            uriSaved = resolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, contentValues)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            contentValues.put(MediaStore.Video.Media.DATE_TAKEN, System.currentTimeMillis())
            contentValues.put(MediaStore.Video.Media.IS_PENDING, 1)
        }

        try {
            CopyFileToPath().execute(resolver, path, uriSaved!!)
        } catch (e: IOException) {
            result.error("IO Exception", e.message, e)
            return
        }

        contentValues.clear()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            contentValues.put(MediaStore.Video.Media.IS_PENDING, 0)
        }

        resolver.update(uriSaved, contentValues, null, null)
        result.success(true)
    }

    private fun getVersionName(result: MethodChannel.Result) {
        val versionName = GetVersionName().execute()
        result.success(versionName)
    }
}