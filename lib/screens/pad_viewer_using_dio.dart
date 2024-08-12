import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';


class PDFDownloaderState {
  Future<void> downloadAndOpenPDF(String url, BuildContext context) async {
    try {

      // Get the temporary directory path
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Define the file path
      String filePath = '$tempPath/user_manual.pdf';

      // Download the PDF file
      Dio dio = Dio();

      await dio.download(url, filePath);

      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
      print('Error downloading PDF: $e');
    }
  }
}
