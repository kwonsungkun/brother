import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdfx/pdfx.dart';

class OcrService {
  static Future<bool> performOcr(String filePath) async {
    bool hasKeyword = false;
    final String fileName = filePath.split('/').last;
    final imageExtensions = ['.png', '.jpg', '.jpeg', '.bmp', '.gif'];
    final isImage = imageExtensions.any((ext) => fileName.toLowerCase().endsWith(ext));
    final isPdf = fileName.toLowerCase().endsWith('.pdf');
    final isTxt = fileName.toLowerCase().endsWith('.txt');

    try {
      if (isTxt) {
        final file = File(filePath);
        final content = await file.readAsString();
        return content.contains('결과보고서');
      }

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);

      if (isImage) {
        final inputImage = InputImage.fromFilePath(filePath);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        hasKeyword = recognizedText.text.replaceAll(RegExp(r'\s+'), '').contains('결과보고서');
      } else if (isPdf) {
        final doc = await PdfDocument.openFile(filePath);
        for (var i = 1; i <= doc.pagesCount; i++) {
          final page = await doc.getPage(i);
          // Render page to image at a higher resolution for better OCR accuracy
          final pageImage = await page.render(width: page.width * 2, height: page.height * 2);
          if (pageImage != null && pageImage.width != null && pageImage.height != null) {
            final inputImage = InputImage.fromBytes(
              bytes: pageImage.bytes,
              metadata: InputImageMetadata(
                size: Size(pageImage.width!.toDouble(), pageImage.height!.toDouble()),
                rotation: InputImageRotation.rotation0deg,
                format: InputImageFormat.bgra8888,
                bytesPerRow: pageImage.width! * 4,
              ),
            );
            final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
            if (recognizedText.text.replaceAll(RegExp(r'\s+'), '').contains('결과보고서')) {
              hasKeyword = true;
              await page.close();
              break;
            }
          }
          await page.close();
        }
        await doc.close();
      }
      await textRecognizer.close();
    } catch (e) {
      print("Error during OCR/file processing: $e");
    }

    return hasKeyword;
  }
}
