import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
import '../entities/ocr_text_result.dart';
import '../repositories/ocr_repository.dart';

class ParseCardDataFromOcrText {
  const ParseCardDataFromOcrText(this._ocrRepository);

  final OcrRepository _ocrRepository;

  Future<Result<CardDraftSuggestion>> call({
    required OcrTextResult frontText,
    OcrTextResult? backText,
    required List<String> imagePaths,
  }) {
    if (frontText.rawText.trim().isEmpty && (backText?.rawText.trim().isEmpty ?? true)) {
      return Future.value(const Failure('OCR output is empty for both front and back images.'));
    }

    return _ocrRepository.parseDraftFromText(
      frontText: frontText,
      backText: backText,
      imagePaths: imagePaths,
    );
  }
}
