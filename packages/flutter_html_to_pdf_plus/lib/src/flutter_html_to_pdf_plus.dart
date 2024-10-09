import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf_plus/src/file_utils.dart';

import 'pdf_print_configuration.dart';
import 'print_config_enums.dart';

/// HTML to PDF Converter
class FlutterHtmlToPdf {
  static const MethodChannel _channel =
      MethodChannel('flutter_html_to_pdf_plus');

  /// Creates PDF Document from HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlContent({
    required String content,
    required PrintPdfConfiguration configuration,
  }) async {
    final File temporaryCreatedHtmlFile =
        await FileUtils.createFileWithStringContent(
      content,
      configuration.htmlFilePath,
    );
    await FileUtils.appendStyleTagToHtmlFile(temporaryCreatedHtmlFile.path);

    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      temporaryCreatedHtmlFile.path,
      configuration.printSize,
      configuration.printOrientation,
      configuration.margins,
    );

    temporaryCreatedHtmlFile.delete();

    return FileUtils.copyAndDeleteOriginalFile(
      generatedPdfFilePath,
      configuration.targetDirectory,
      configuration.targetName,
    );
  }

  /// Creates PDF Document from File that contains HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlFile({
    required File htmlFile,
    required PrintPdfConfiguration configuration,
  }) async {
    await FileUtils.appendStyleTagToHtmlFile(htmlFile.path);
    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      htmlFile.path,
      configuration.printSize,
      configuration.printOrientation,
      configuration.margins,
    );

    return FileUtils.copyAndDeleteOriginalFile(
      generatedPdfFilePath,
      configuration.targetDirectory,
      configuration.targetName,
    );
  }

  /// Creates PDF Document from path to File that contains HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlFilePath({
    required String htmlFilePath,
    required PrintPdfConfiguration configuration,
  }) async {
    await FileUtils.appendStyleTagToHtmlFile(htmlFilePath);
    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      htmlFilePath,
      configuration.printSize,
      configuration.printOrientation,
      configuration.margins,
    );

    return FileUtils.copyAndDeleteOriginalFile(
      generatedPdfFilePath,
      configuration.targetDirectory,
      configuration.targetName,
    );
  }

  /// Assumes the invokeMethod call will return successfully
  static Future<String> _convertFromHtmlFilePath(
    String htmlFilePath,
    PrintSize printSize,
    PrintOrientation printOrientation,
    PdfPageMargin pageMargin,
  ) async {
    int width = printSize
        .getDimensionsInPixels[printOrientation.getWidthDimensionIndex];
    int height = printSize
        .getDimensionsInPixels[printOrientation.getHeightDimensionIndex];

    return await _channel.invokeMethod(
      'convertHtmlToPdf',
      <String, dynamic>{
        'htmlFilePath': htmlFilePath,
        'width': width,
        'height': height,
        'printSize': printSize.printSizeKey,
        'orientation': printOrientation.orientationKey,
        'margins': [
          pageMargin.left,
          pageMargin.top,
          pageMargin.right,
          pageMargin.bottom,
        ],
      },
    ) as String;
  }
}
