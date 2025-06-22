// import 'package:flutter/material.dart';
// import 'package:pdf_download_example/permission_helper/permission_helper.dart';
// import 'package:pdf_download_example/provider/pdf_download_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'features/pdf_downloader_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//  await requestNotificationPermission();
//  await requestManageStoragePermission();
//  await StoragePermissionHandler().checkAndRequestPermissions(context);
//   checkStoragePermission();
//  await requestStoragePermissions();
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   const initializationSettings = InitializationSettings(
//     android: AndroidInitializationSettings("@mipmap/ic_launcher"), // Provide your app's icon here
//   );
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   final provider = PdfDownloadProvider(flutterLocalNotificationsPlugin);
//   await provider.initializeNotificationListener(); // Initialize the listener
//
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => provider,
//       child: const MyApp(),
//     ),
//   );
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PDF Download App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const PdfDownloadPage(),
//     );
//   }
// }
// Future<void> requestNotificationPermission() async {
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// }
//
// Future<void> requestManageStoragePermission() async {
//   if (await Permission.manageExternalStorage.isDenied) {
//     openAppSettings();
//   }
// }
//
// Future<void> requestStoragePermissions() async {
//   PermissionStatus status = await Permission.storage.request();
//   if (status.isGranted) {
//     // Continue with your code
//   }
// }
//
// // void checkStoragePermission() async {
// //   var status = await Permission.manageExternalStorage.status;
// //   if (status.isGranted) {
// //     print("Storage permission granted.");
// //   } else {
// //     print("Storage permission not granted.");
// //   }
// // }
//



import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:pdf_download_example/permission_helper/permission_helper.dart';
import 'package:pdf_download_example/provider/pdf_download_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'features/pdf_downloader_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoragePermissionHandler().requestNotificationPermission();
  await StoragePermissionHandler().storagePermission(Permission.storage);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await PdfDownloadProvider(flutterLocalNotificationsPlugin).initializeNotificationListener();

  runApp(
    ChangeNotifierProvider(
      create: (context) => PdfDownloadProvider(flutterLocalNotificationsPlugin),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Download App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PdfDownloadPage(),
    );
  }
}


