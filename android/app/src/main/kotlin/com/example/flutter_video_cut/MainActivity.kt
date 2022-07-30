package com.example.flutter_video_cut

import android.content.Intent
import android.graphics.Bitmap
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import androidx.annotation.RequiresApi
import androidx.core.net.toFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import use_cases.GetUriFromPath
import java.io.ByteArrayOutputStream
import java.io.File

class MainActivity: FlutterActivity() {
    //private var sharedData: String = ""

    /*override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //callHandler()
    }*/

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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val file = File(path);
            // TODO: Get Resolution of video, https://stackoverflow.com/questions/9077436/how-to-determine-video-width-and-height-on-android, https://www.google.com/search?q=get+dimensions+of+video+in+android+in+java&sxsrf=ALiCzsbQ0TjbHFeLnYP8ieNc2yGAzEkzzw%3A1659203851084&ei=C3HlYu_mBM-p5OUPjoWE4Aw&ved=0ahUKEwivmJ2BmKH5AhXPFLkGHY4CAcwQ4dUDCA4&uact=5&oq=get+dimensions+of+video+in+android+in+java&gs_lcp=Cgdnd3Mtd2l6EAMyBwghEKABEAoyBwghEKABEAoyBwghEKABEAoyBAghEBU6BwgAEEcQsAM6BQghEKABOgoIIRAeEA8QFhAdOggIIRAeEBYQHUoECEEYAEoECEYYAFC5A1iGCmC-CmgBcAF4AIAB6wGIAfAJkgEFMC41LjKYAQCgAQHIAQjAAQE&sclient=gws-wiz
            val size = Size(500, 500)
            val bitmap = ThumbnailUtils.createVideoThumbnail(file, size, null)

            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
            val byteArray = stream.toByteArray()
            bitmap.recycle()

            result.success(byteArray)
        } else {
            // TODO: Old devices, https://developer.android.com/reference/android/media/ThumbnailUtils.html#createVideoThumbnail(java.lang.String,%20int)
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