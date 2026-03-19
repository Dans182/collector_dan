import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
import '../entities/ocr_text_result.dart';

abstract interface class OcrRepository {
  Future<Result<OcrTextResult>> extractTextFromImage(String imagePath);

  Future<Result<CardDraftSuggestion>> parseDraftFromText({
    required OcrTextResult frontText,
    OcrTextResult? backText,
    required List<String> imagePaths,
  });
}
