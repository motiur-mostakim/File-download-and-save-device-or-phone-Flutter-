import 'package:flutter/material.dart';
import 'package:pdf_download_example/provider/pdf_download_provider.dart';
import 'package:provider/provider.dart';

import 'features/pdf_downloader_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PdfDownloadProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PDF Download with Provider',
        home: PdfDownloadPage(),
      ),
    );
  }
}