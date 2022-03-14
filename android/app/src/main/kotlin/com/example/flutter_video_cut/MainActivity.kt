package com.example.flutter_video_cut

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Parcelable
import android.provider.MediaStore
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import javautils.FileUtils
import javautils.GenericFileProvider
import java.io.File

class MainActivity: FlutterActivity() {
    private var sharedData: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        callHandler()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.flutter_video_cut.path")
            .setMethodCallHandler { call, result ->
                if (call.method == "getSharedData") {
                    callHandler()
                    result.success(sharedData)
                    sharedData = ""
                }
                else if (call.method == "shareFiles") {
                    val paths = call.arguments as ArrayList<String>
                    callShareFilesHandler(paths)
                }
                else if (call.method == "saveFileInGallery") {
                    val arguments = call.arguments as ArrayList<String>
                    callSaveFileInGallery(arguments)
                }
            }
    }

    private fun callHandler() {
        if (intent?.action == Intent.ACTION_SEND) {
            if (intent.type!!.contains("video")) {
                (intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri)?.let { uri ->
                    val filePath = FileUtils(context).getPath(uri)
                    sharedData = filePath
                }
            }
        }
    }

    private fun callShareFilesHandler(paths : ArrayList<String>) {
        val uris = ArrayList<Uri>()
        for (path in paths) {
            val file = File(path)
            var uri: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                GenericFileProvider.getUriForFile(
                    context,
                    "com.ferreira.myprovider",
                    file
                );
            } else {
                Uri.fromFile(file)
            }
            
            uris.add(uri)
        }

        val intent = Intent()
        intent.setType("video/*")
        intent.setAction(Intent.ACTION_SEND_MULTIPLE)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)

        startActivity(Intent.createChooser(intent, "Compartilhar Vídeos"))
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
    }

}
