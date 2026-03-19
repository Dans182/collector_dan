import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
import '../entities/card_scan_image.dart';
import '../entities/ocr_text_result.dart';
import '../repositories/card_draft_parser.dart';

class ParseCardDataFromOcrText {
  const ParseCardDataFromOcrText(this._draftParser);

  final CardDraftParser _draftParser;

  Future<Result<CardDraftSuggestion>> call({
    required OcrTextResult frontText,
    OcrTextResult? backText,
    required List<CardScanImage> images,
  }) {
    if (images.isEmpty) {
      return Future.value(const Failure('At least one image is required to parse a card draft.'));
    }

    if (frontText.rawText.trim().isEmpty && (backText?.rawText.trim().isEmpty ?? true)) {
      return Future.value(const Failure('OCR output is empty for both front and back images.'));
    }

    return _draftParser.parse(
      frontText: frontText,
      backText: backText,
      images: images,
    );
  }
}
