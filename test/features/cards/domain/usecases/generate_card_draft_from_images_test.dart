import 'package:collector_dan/core/result.dart';
import 'package:collector_dan/features/cards/domain/entities/card_draft_suggestion.dart';
import 'package:collector_dan/features/cards/domain/entities/ocr_text_result.dart';
import 'package:collector_dan/features/cards/domain/repositories/ocr_repository.dart';
import 'package:collector_dan/features/cards/domain/usecases/extract_text_from_card_image.dart';
import 'package:collector_dan/features/cards/domain/usecases/generate_card_draft_from_images.dart';
import 'package:collector_dan/features/cards/domain/usecases/parse_card_data_from_ocr_text.dart';
import 'package:test/test.dart';

void main() {
  group('GenerateCardDraftFromImages', () {
    test('returns a parsed draft when OCR succeeds', () async {
      final repository = _FakeOcrRepository();
      final useCase = GenerateCardDraftFromImages(
        extractText: ExtractTextFromCardImage(repository),
        parseCardData: ParseCardDataFromOcrText(repository),
      );

      final result = await useCase(
        frontImagePath: '/tmp/front.jpg',
        backImagePath: '/tmp/back.jpg',
      );

      expect(result, isA<Success<CardDraftSuggestion>>());
      final draft = (result as Success<CardDraftSuggestion>).value;
      expect(draft.playerName, 'Ken Griffey Jr.');
      expect(draft.year, 1989);
      expect(draft.setName, 'Topps Traded');
    });

    test('fails when the front image path is empty', () async {
      final repository = _FakeOcrRepository();
      final useCase = GenerateCardDraftFromImages(
        extractText: ExtractTextFromCardImage(repository),
        parseCardData: ParseCardDataFromOcrText(repository),
      );

      final result = await useCase(frontImagePath: '');

      expect(result, isA<Failure<CardDraftSuggestion>>());
    });
  });
}

class _FakeOcrRepository implements OcrRepository {
  @override
  Future<Result<OcrTextResult>> extractTextFromImage(String imagePath) async {
    return Success(
      OcrTextResult(
        rawText: imagePath.contains('front') ? '1989 Ken Griffey Jr. Topps Traded #41T Rookie' : 'Seattle Mariners',
        lines: const [],
        averageConfidence: 0.93,
      ),
    );
  }

  @override
  Future<Result<CardDraftSuggestion>> parseDraftFromText({
    required OcrTextResult frontText,
    OcrTextResult? backText,
    required List<String> imagePaths,
  }) async {
    return Success(
      CardDraftSuggestion(
      playerName: 'Ken Griffey Jr.',
      year: 1989,
      setName: 'Topps Traded',
      cardNumber: '41T',
      isRookieCard: true,
      sourceImagePaths: imagePaths,
      rawExtractedText: [frontText.rawText, backText?.rawText].whereType<String>().join('\n'),
      overallConfidence: 0.93,
      ),
    );
  }
}
