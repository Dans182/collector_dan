import 'package:collector_dan/core/result.dart';
import 'package:collector_dan/features/cards/domain/entities/card_draft_suggestion.dart';
import 'package:collector_dan/features/cards/domain/entities/card_scan_image.dart';
import 'package:collector_dan/features/cards/domain/entities/ocr_text_result.dart';
import 'package:collector_dan/features/cards/domain/repositories/card_draft_parser.dart';
import 'package:collector_dan/features/cards/domain/repositories/ocr_repository.dart';
import 'package:collector_dan/features/cards/domain/usecases/extract_text_from_card_image.dart';
import 'package:collector_dan/features/cards/domain/usecases/generate_card_draft_from_images.dart';
import 'package:collector_dan/features/cards/domain/usecases/parse_card_data_from_ocr_text.dart';
import 'package:test/test.dart';

void main() {
  group('GenerateCardDraftFromImages', () {
    test('returns a parsed draft when OCR succeeds', () async {
      final ocrRepository = _FakeOcrRepository();
      final draftParser = _FakeCardDraftParser();
      final useCase = GenerateCardDraftFromImages(
        extractText: ExtractTextFromCardImage(ocrRepository),
        parseCardData: ParseCardDataFromOcrText(draftParser),
      );

      final result = await useCase(
        images: const [
          CardScanImage(path: '/tmp/front.jpg', side: CardScanSide.front),
          CardScanImage(path: '/tmp/back.jpg', side: CardScanSide.back),
        ],
      );

      expect(result, isA<Success<CardDraftSuggestion>>());
      final draft = (result as Success<CardDraftSuggestion>).value;
      expect(draft.playerName, 'Ken Griffey Jr.');
      expect(draft.year, 1989);
      expect(draft.setName, 'Topps Traded');
      expect(draft.sourceImagePaths, ['/tmp/front.jpg', '/tmp/back.jpg']);
    });

    test('fails when there is no front image', () async {
      final ocrRepository = _FakeOcrRepository();
      final draftParser = _FakeCardDraftParser();
      final useCase = GenerateCardDraftFromImages(
        extractText: ExtractTextFromCardImage(ocrRepository),
        parseCardData: ParseCardDataFromOcrText(draftParser),
      );

      final result = await useCase(
        images: const [
          CardScanImage(path: '/tmp/back.jpg', side: CardScanSide.back),
        ],
      );

      expect(result, isA<Failure<CardDraftSuggestion>>());
    });

    test('fails when duplicate back images are provided', () async {
      final ocrRepository = _FakeOcrRepository();
      final draftParser = _FakeCardDraftParser();
      final useCase = GenerateCardDraftFromImages(
        extractText: ExtractTextFromCardImage(ocrRepository),
        parseCardData: ParseCardDataFromOcrText(draftParser),
      );

      final result = await useCase(
        images: const [
          CardScanImage(path: '/tmp/front.jpg', side: CardScanSide.front),
          CardScanImage(path: '/tmp/back-1.jpg', side: CardScanSide.back),
          CardScanImage(path: '/tmp/back-2.jpg', side: CardScanSide.back),
        ],
      );

      expect(result, isA<Failure<CardDraftSuggestion>>());
    });
  });
}

class _FakeOcrRepository implements OcrRepository {
  @override
  Future<Result<OcrTextResult>> extractTextFromImage(CardScanImage image) async {
    return Success(
      OcrTextResult(
        rawText: image.side == CardScanSide.front
            ? '1989 Ken Griffey Jr. Topps Traded #41T Rookie'
            : 'Seattle Mariners',
        lines: const [],
        averageConfidence: 0.93,
      ),
    );
  }
}

class _FakeCardDraftParser implements CardDraftParser {
  @override
  Future<Result<CardDraftSuggestion>> parse({
    required OcrTextResult frontText,
    OcrTextResult? backText,
    required List<CardScanImage> images,
  }) async {
    return Success(
      CardDraftSuggestion(
        playerName: 'Ken Griffey Jr.',
        year: 1989,
        setName: 'Topps Traded',
        cardNumber: '41T',
        isRookieCard: true,
        sourceImagePaths: [for (final image in images) image.path],
        rawExtractedText: [frontText.rawText, backText?.rawText].whereType<String>().join('\n'),
        overallConfidence: 0.93,
        fieldConfidence: const {
          'playerName': 0.98,
          'year': 0.99,
          'setName': 0.88,
        },
      ),
    );
  }
}
