import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
import '../entities/card_scan_image.dart';
import '../entities/ocr_text_result.dart';

abstract interface class CardDraftParser {
  Future<Result<CardDraftSuggestion>> parse({
    required OcrTextResult frontText,
    OcrTextResult? backText,
    required List<CardScanImage> images,
  });
}
