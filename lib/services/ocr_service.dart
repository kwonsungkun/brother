import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  static Future<bool> performOcr(String filePath) async {
    if (filePath.isEmpty) {
      return false;
    }
    try {
      final inputImage = InputImage.fromFilePath(filePath);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      final text = recognizedText.text;
      return text.replaceAll(RegExp(r'\s+'), '').contains('결과보고서');
    } catch (e) {
      print("OCR 처리 중 오류가 발생했습니다: $e");
      return false;
    }
  }
}
