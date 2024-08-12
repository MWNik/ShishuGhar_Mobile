// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
//
// class UserManualPF extends StatefulWidget {
//   final File file;
//
//   UserManualPF({super.key, required this.file});
//
//   @override
//   State<UserManualPF> createState() => _UserManualPFState();
// }
//
// class _UserManualPFState extends State<UserManualPF> {
//   late PDFViewController controller;
//   int page = 0;
//   int indexPag = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(
//         text: 'User Manual',
//         onTap: () => Navigator.pop(context),
//       ),
//       body: PDFView(
//         filePath: widget.file.path,
//         autoSpacing: true,
//         // swipeHorizontal: true,
//         enableSwipe: true,
//
//         pageSnap: false,
//         pageFling: false,
//         onRender: (pages) => setState(() => this.page = pages!),
//         onViewCreated: (controller) =>
//             setState(() => this.controller = controller),
//         onPageChanged: (indexPage, _) =>
//             setState(() => this.indexPag = indexPage!),
//       ),
//     );
//   }
// }
