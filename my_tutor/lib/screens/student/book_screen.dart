import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
class BookScreen extends StatefulWidget {
  BookScreen({Key? key, }) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/pdf/book.pdf'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Magic Of thinking Big'),
      ),
      body: PdfView(
        controller: pdfController,
      ),
    );
  }
}

// PdfView(
// controller: pdfController,
// ),

