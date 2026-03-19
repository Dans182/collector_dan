import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
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
    required String frontImagePath,
    String? backImagePath,
  }) async {
    if (frontImagePath.trim().isEmpty) {
      return const Failure('A front image is required to generate a card draft.');
    }

    final frontResult = await _extractText(frontImagePath);
    if (frontResult is Failure<OcrTextResult>) {
      return Failure(frontResult.message);
    }

    OcrTextResult? backText;
    if (backImagePath != null && backImagePath.trim().isNotEmpty) {
      final backResult = await _extractText(backImagePath);
      if (backResult is Failure<OcrTextResult>) {
        return Failure(backResult.message);
      }
      backText = (backResult as Success<OcrTextResult>).value;
    }

    return _parseCardData(
      frontText: (frontResult as Success<OcrTextResult>).value,
      backText: backText,
      imagePaths: [frontImagePath, if (backImagePath != null && backImagePath.trim().isNotEmpty) backImagePath],
    );
  }
}
