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



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

class PdfDownloadProvider extends ChangeNotifier {
  String status = "";

  static const MethodChannel _channel =
  MethodChannel('com.example.filesaver/channel');

  Future<void> downloadAndSave(String url, String fileName,BuildContext context) async {
    status = "Downloading.....";
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(status)));
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

      final String result = await _channel.invokeMethod(
        'saveFileToDownloads',
        {
          'fileName': fileName,
          'bytes': bytes,
          'mimeType': mimeType,
        },
      );

      status = result;
      notifyListeners();
    } catch (e) {
      status = "Error: $e";
      notifyListeners();
    }
  }
}
