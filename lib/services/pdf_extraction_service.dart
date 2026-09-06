import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Extracts plain text from PDF file bytes using Syncfusion.
class PdfExtractionService {
  PdfExtractionService._();
  static final PdfExtractionService instance = PdfExtractionService._();

  /// Extract all text from [pdfBytes].
  /// Returns an empty string if extraction fails.
  String extractText(Uint8List pdfBytes) {
    try {
      final document = PdfDocument(inputBytes: pdfBytes);
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      document.dispose();
      return text;
    } catch (e) {
      return '';
    }
  }
}
