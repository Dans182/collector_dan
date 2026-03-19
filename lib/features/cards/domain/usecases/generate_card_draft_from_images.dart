import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
import '../entities/card_scan_image.dart';
import '../entities/ocr_text_result.dart';
import 'extract_text_from_card_image.dart';
import 'parse_card_data_from_ocr_text.dart';

class GenerateCardDraftFromImages {
  const GenerateCardDraftFromImages({
    required ExtractTextFromCardImage extractText,
    required ParseCardDataFromOcrText parseCardData,
  })  : _extractText = extractText,
        _parseCardData = parseCardData;

  final ExtractTextFromCardImage _extractText;
  final ParseCardDataFromOcrText _parseCardData;

  Future<Result<CardDraftSuggestion>> call({
    required List<CardScanImage> images,
  }) async {
    final validationError = _validate(images);
    if (validationError != null) {
      return Failure(validationError);
    }

    final frontImage = images.firstWhere((image) => image.side == CardScanSide.front);
    final frontResult = await _extractText(frontImage);
    if (frontResult is Failure<OcrTextResult>) {
      return Failure(frontResult.message);
    }

    final backImage = _findSingleImageBySide(images, CardScanSide.back);
    OcrTextResult? backText;
    if (backImage != null) {
      final backResult = await _extractText(backImage);
      if (backResult is Failure<OcrTextResult>) {
        return Failure(backResult.message);
      }
      backText = (backResult as Success<OcrTextResult>).value;
    }

    return _parseCardData(
      frontText: (frontResult as Success<OcrTextResult>).value,
      backText: backText,
      images: images,
    );
  }

  String? _validate(List<CardScanImage> images) {
    if (images.isEmpty) {
      return 'At least one scan image is required to generate a card draft.';
    }

    if (images.any((image) => image.path.trim().isEmpty)) {
      return 'All scan images must include a non-empty path.';
    }

    final frontCount = images.where((image) => image.side == CardScanSide.front).length;
    if (frontCount != 1) {
      return 'Exactly one front image is required to generate a card draft.';
    }

    final backCount = images.where((image) => image.side == CardScanSide.back).length;
    if (backCount > 1) {
      return 'Only one back image is supported for OCR draft generation.';
    }

    return null;
  }

  CardScanImage? _findSingleImageBySide(List<CardScanImage> images, CardScanSide side) {
    for (final image in images) {
      if (image.side == side) {
        return image;
      }
    }
    return null;
  }
}
