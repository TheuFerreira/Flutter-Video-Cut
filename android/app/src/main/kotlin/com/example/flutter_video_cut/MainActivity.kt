package com.example.flutter_video_cut

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Parcelable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import javautils.FileUtils
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
                } else if (call.method == "shareFiles") {
                    val paths = call.arguments as ArrayList<String>;
                    callShareFilesHandler(paths);
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
        val intent = Intent()
        intent.action = Intent.ACTION_SEND_MULTIPLE
        intent.type = "video/*"

        val uriFiles = ArrayList<Uri>()
        for (path in paths) {
            val file = File(path)
            val uri = Uri.fromFile(file)
            uriFiles.add(uri)
        }

        intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uriFiles)
        startActivity(Intent.createChooser(intent, "Compartilhar Vídeos"))
    }
}
