import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/pdf_download_provider.dart';

class PdfDownloadPage extends StatelessWidget {
  const PdfDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PdfDownloadProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Download')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
            onPressed: () {
              provider.downloadAndSave(
                'https://d2r44w8tsw4pqe.cloudfront.net/assets/7bd8654c-635c-449b-896b-300ff2b74314/parenting-e-book-shishur-valo-ovvas-preview.pdf',
                'sample_pdf_download.pdf',
                context,
              );
            },
            child: const Text("Download PDF"),
          ),
        ]),
      ),
    );
  }
}