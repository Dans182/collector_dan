import '../../../../core/result.dart';
import '../entities/card_scan_image.dart';
import '../entities/ocr_text_result.dart';

abstract interface class OcrRepository {
  Future<Result<OcrTextResult>> extractTextFromImage(CardScanImage image);
}
