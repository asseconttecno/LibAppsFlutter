import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';

class PdfPageMargin {
  final int top;
  final int bottom;
  final int left;
  final int right;

  const PdfPageMargin({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
}

/// Print Pdf Configuration
class PrintPdfConfiguration {
  final String targetDirectory;
  final String targetName;
  final PdfPageMargin margins;
  final PrintSize printSize;
  final PrintOrientation printOrientation;

  /// `targetDirectory` is the desired path for the Pdf file.
  ///
  /// `targetName` is the name of the Pdf file
  ///
  /// `margins` is the page margin of the Pdf file
  ///
  /// `printSize` is the print size of the Pdf file
  ///
  /// `printOrientation` is the print orientation of the Pdf file
  PrintPdfConfiguration({
    required this.targetDirectory,
    required this.targetName,
    this.margins =
        const PdfPageMargin(top: 50, bottom: 50, left: 50, right: 50),
    this.printSize = PrintSize.A4,
    this.printOrientation = PrintOrientation.Portrait,
  });

  /// Returns the final path for temporary Html File
  String get htmlFilePath => "$targetDirectory/$targetName.html";
}
