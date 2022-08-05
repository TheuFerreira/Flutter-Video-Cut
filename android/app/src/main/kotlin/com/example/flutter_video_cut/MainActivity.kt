package com.example.flutter_video_cut

import android.content.Intent
import android.graphics.Bitmap
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import use_cases.ConvertBitmapToByteArray
import use_cases.GetDimensionsOfVideo
import use_cases.GetUriFromPath
import java.io.File

class MainActivity: FlutterActivity() {
    //private var sharedData: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {

        if (intent.getIntExtra("org.chromium.chrome.extra.TASK_ID", -1) == this.taskId) {
            this.finish()
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
        super.onCreate(savedInstanceState)
        //callHandler()
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
                    /*"getSharedData" -> {
                        callHandler()
                        result.success(sharedData)
                        sharedData = ""
                    }
                    "saveFileInGallery" -> {
                        //val arguments = call.arguments as ArrayList<String>
                        //callSaveFileInGallery(arguments)
                    }*/
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

    /*private fun callHandler() {
        if (intent?.action == Intent.ACTION_SEND) {
            if (intent.type!!.contains("video")) {
                (intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri)?.let { uri ->
                    val filePath = FileUtils(context).getPath(uri)
                    sharedData = filePath
                }
            }
        }
    }

    private fun callSaveFileInGallery(arguments : ArrayList<String>) {
        var originalFilePath = arguments[0]
        var originalFile = File(originalFilePath)

        var newName = arguments[1]
        var dcim = context.getExternalFilesDir(Environment.DIRECTORY_DCIM)
        val newFilePath = "$dcim//$newName"
        val newfile = File(newFilePath)

        if (newfile.exists()) {
            Log.i("New File", "Exists")
        } else {
            Log.i("New File", "Not Exists")
            originalFile.copyTo(newfile, true)
        }
    }*/

}