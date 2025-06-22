// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:dio/dio.dart';
//
// class PdfDownloadProvider extends ChangeNotifier {
//   String status = "";
//
//   static const MethodChannel _channel =
//   MethodChannel('com.example.filesaver/channel');
//
//   Future<void> downloadAndSave(String url, String fileName) async {
//     status = "Downloading...";
//     notifyListeners();
//
//     try {
//       final response = await Dio().get<List<int>>(
//         url,
//         options: Options(responseType: ResponseType.bytes),
//       );
//       final bytes = Uint8List.fromList(response.data!);
//
//       final String result = await _channel.invokeMethod(
//         'saveFileToDownloads',
//         {'fileName': fileName, 'bytes': bytes},
//       );
//
//       status = result;
//       notifyListeners();
//     } catch (e) {
//       status = "Error: $e";
//       notifyListeners();
//     }
//   }
// }

// download without local notification

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:dio/dio.dart';
//
// class PdfDownloadProvider extends ChangeNotifier {
//   String status = "";
//
//   static const MethodChannel _channel =
//   MethodChannel('com.example.filesaver/channel');
//
//   Future<void> downloadAndSave(String url, String fileName,BuildContext context) async {
//     status = "Downloading.....";
//     ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(status)));
//     notifyListeners();
//     try {
//       final response = await Dio().get<List<int>>(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//           validateStatus: (status) => status! < 500,
//         ),
//       );
//
//       final bytes = Uint8List.fromList(response.data!);
//       String mimeType = '';
//       if (url.endsWith('.pdf')) {
//         mimeType = 'application/pdf';
//       } else if (url.endsWith('.png')) {
//         mimeType = 'image/png';
//       } else if (url.endsWith('.jpg') || url.endsWith('.jpeg')) {
//         mimeType = 'image/jpeg';
//       } else {
//         mimeType = 'application/octet-stream';
//       }
//
//       final String result = await _channel.invokeMethod(
//         'saveFileToDownloads',
//         {
//           'fileName': fileName,
//           'bytes': bytes,
//           'mimeType': mimeType,
//         },
//       );
//
//       status = result;
//       notifyListeners();
//     } catch (e) {
//       status = "Error: $e";
//       notifyListeners();
//     }
//   }
// }


// download with local notification

//
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class PdfDownloadProvider extends ChangeNotifier {
//   String status = "";
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   PdfDownloadProvider(this.flutterLocalNotificationsPlugin);
//
//   static const MethodChannel _channel =
//   MethodChannel('com.example.filesaver/channel');
//
//   Future<void> downloadAndSave(String url, String fileName, BuildContext context) async {
//     status = "Downloading.....";
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
//     notifyListeners();
//
//     try {
//       final response = await Dio().get<List<int>>(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//           validateStatus: (status) => status! < 500,
//         ),
//       );
//
//       final bytes = Uint8List.fromList(response.data!);
//       String mimeType = '';
//       if (url.endsWith('.pdf')) {
//         mimeType = 'application/pdf';
//       } else if (url.endsWith('.png')) {
//         mimeType = 'image/png';
//       } else if (url.endsWith('.jpg') || url.endsWith('.jpeg')) {
//         mimeType = 'image/jpeg';
//       } else {
//         mimeType = 'application/octet-stream';
//       }
//
//       final String result = await _channel.invokeMethod(
//         'saveFileToDownloads',
//         {
//           'fileName': fileName,
//           'bytes': bytes,
//           'mimeType': mimeType,
//         },
//       );
//
//       status = result;
//       notifyListeners();
//
//       // Send notification about download completion
//       await _showNotification('Download Complete', 'The file has been downloaded successfully.');
//     } catch (e) {
//       status = "Error: $e";
//       notifyListeners();
//
//       // Send notification about download failure
//       await _showNotification('Download Failed', 'An error occurred during the download.');
//     }
//   }
//
//   Future<void> _showNotification(String title, String body) async {
//     const androidDetails = AndroidNotificationDetails(
//       'download_channel', 'Download Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const notificationDetails = NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }


// download with local notification and open file
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class PdfDownloadProvider extends ChangeNotifier {
  String status = "";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? _downloadedFilePath;

  PdfDownloadProvider(this.flutterLocalNotificationsPlugin);

  static const MethodChannel _channel =
  MethodChannel('com.example.filesaver/channel');

  Future<void> downloadAndSave(String url, String fileName, BuildContext context) async {
    status = "Downloading.....";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
    notifyListeners();

    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );
      print("PDF Downloaded: $response");
      final bytes = Uint8List.fromList(response.data!);
      String mimeType = '';
      if (url.endsWith('.pdf')) {
        mimeType = 'application/pdf';
      } else if (url.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (url.endsWith('.jpg') || url.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else {
        mimeType = 'application/octet-stream';
      }

      final String path = await _channel.invokeMethod('saveFileToDownloads', {
        'fileName': fileName,
        'bytes': bytes,
        'mimeType': mimeType,
      });

      _downloadedFilePath = path;
      final result = await OpenFile.open(_downloadedFilePath);
      print("Open result: ${result.message}");

      notifyListeners();
      await _showNotification(
        'Download Complete',
        'The file has been downloaded successfully.',
        _downloadedFilePath,
      );
    } catch (e) {
      status = "Error: $e";
      notifyListeners();
      await _showNotification(
        'Download Failed',
        'An error occurred during the download.',
        null,
      );
    }
  }

  Future<void> _showNotification(String title, String body, String? filePath) async {
    const androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: filePath,
    );
  }

  Future<void> _onNotificationTap(NotificationResponse notificationResponse) async {
    final String? filePath = notificationResponse.payload;
    if (filePath != null) {
      print("Trying to open file: $filePath");
      final result = await OpenFile.open(filePath);
      print("Result: ${result.message}");
    } else {
      print('No valid file path in notification payload.');
    }
  }



  // Initialize notification listener
  Future<void> initializeNotificationListener() async {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (notificationResponse) async {
        await _onNotificationTap(notificationResponse); // Handle tap event
      },
    );
  }
}
