//package com.example.pdf_download_example
//
//import android.content.ContentValues
//import android.os.Environment
//import android.provider.MediaStore
//import java.io.OutputStream
//
//import androidx.annotation.NonNull
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
//    private val CHANNEL = "com.example.filesaver/channel"
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                if (call.method == "saveFileToDownloads") {
//                    val fileName = call.argument<String>("fileName")
//                    val bytes = call.argument<ByteArray>("bytes")
//
//                    if (fileName != null && bytes != null) {
//                        try {
//                            val values = ContentValues().apply {
//                                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
//                                put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
//                                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
//                            }
//
//                            val resolver = contentResolver
//                            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
//
//                            uri?.let {
//                                val outputStream: OutputStream? = resolver.openOutputStream(it)
//                                outputStream?.write(bytes)
//                                outputStream?.close()
//                                result.success("Saved to Downloads")
//                            } ?: result.error("ERROR", "Failed to create file", null)
//
//                        } catch (e: Exception) {
//                            result.error("ERROR", "Exception: ${e.message}", null)
//                        }
//                    } else {
//                        result.error("ERROR", "Missing arguments", null)
//                    }
//                } else {
//                    result.notImplemented()
//                }
//            }
//    }
//}




package com.example.pdf_download_example

import android.content.ContentValues
import android.os.Environment
import android.provider.MediaStore
import java.io.OutputStream

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
                    val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream" // ✅ add this

                    if (fileName != null && bytes != null) {
                        try {
                            val values = ContentValues().apply {
                                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                                put(MediaStore.MediaColumns.MIME_TYPE, mimeType) // ✅ use dynamic mime
                                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                            }

                            val resolver = contentResolver
                            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)

                            uri?.let {
                                val outputStream: OutputStream? = resolver.openOutputStream(it)
                                outputStream?.write(bytes)
                                outputStream?.close()
                                result.success("Saved to Downloads")
                            } ?: result.error("ERROR", "Failed to create file", null)

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
