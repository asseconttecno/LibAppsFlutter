# flutter_html_to_pdf_plus

[![pub package](https://img.shields.io/pub/v/flutter_html_to_pdf_plus.svg)](https://pub.dartlang.org/packages/flutter_html_to_pdf_plus)

Flutter plugin for generating PDF files from HTML

### Usage

#### From a raw HTML content

```dart 
var targetPath = "/your/sample/path";
var targetFileName = "example_pdf_file"

var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
  content: htmlContent, 
  configuration: PdfPrinterConfiguration(
    targetPath: targetPath, 
    targetFileName: targetFileName,
    margins: PdfPrinterMargins(top: 10, bottom: 10, left: 10, right: 10),
    orientation: PrintOrientation.Landscape,
    printSize: PrintSize.A4
  ),
);
```

#### From an HTML file
```dart
var file = File("/sample_path/example.html");
var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlFile(
  htmlFile: file,
  configuration: PdfPrinterConfiguration(
    targetPath: targetPath, 
    targetFileName: targetFileName,
    margins: PdfPrinterMargins(top: 10, bottom: 10, left: 10, right: 10),
    orientation: PrintOrientation.Landscape,
    printSize: PrintSize.A4
  ),
);
```

#### From an HTML file path
```dart
var filePath = "/sample_path/example.html";
var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlFilePath(
  htmlFilePath: filePath,
  configuration: PdfPrinterConfiguration(
    targetPath: targetPath, 
    targetFileName: targetFileName,
    margins: PdfPrinterMargins(top: 10, bottom: 10, left: 10, right: 10),
    orientation: PrintOrientation.Landscape,
    printSize: PrintSize.A4
  ),
);
```

> /!\ Caveats : Customization of orientation is not supported on iOS. Any config will be ignored.

#### Images
If your want to add local image from device to your **HTML** you need to pass path to image as ***src*** value.

```html
<img src="file:///storage/example/your_sample_image.png" alt="web-img">
```
or if you want to use the image ***File*** object
```html
<img src="${imageFile.path}" alt="web-img">
```

Many images inside your document can significantly affect the final file size so we suggest to use [flutter_image_compress](https://github.com/OpenFlutter/flutter_image_compress) plugin to compress images before generating PDF.

## Contributing

If you want to contribute, please submit a [pull request](https://github.com/originoss/flutter_html_to_pdf_plus/pulls) or [create an issue](https://github.com/originoss/flutter_html_to_pdf_plus/issues).

## Credits

- Thanks to [Afur](https://github.com/afur) for the initial work on this plugin
- Thanks to [raister21](https://github.com/raister21) for their work on PDF Size & Orientation
- Thanks to [wiseminds](https://github.com/wiseminds) for the inspiration for margins customization
