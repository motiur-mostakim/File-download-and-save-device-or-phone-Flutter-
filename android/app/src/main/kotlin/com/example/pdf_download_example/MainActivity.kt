package com.example.pdf_download_example

import android.os.Environment
import java.io.File
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.filesaver/channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveFileToDownloads") {
                    val fileName = call.argument<String>("fileName")
                    val bytes = call.argument<ByteArray>("bytes")

                    if (fileName != null && bytes != null) {
                        try {
                            // ✅ Get Downloads directory
                            val downloadsFolder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                            if (!downloadsFolder.exists()) {
                                downloadsFolder.mkdirs()
                            }

                            // ✅ Create file and write bytes
                            val file = File(downloadsFolder, fileName)
                            file.writeBytes(bytes)

                            // ✅ Return absolute file path to Flutter
                            result.success(file.absolutePath)
                        } catch (e: Exception) {
                            result.error("ERROR", "Exception: ${e.message}", null)
                        }
                    } else {
                        result.error("ERROR", "Missing arguments", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}

