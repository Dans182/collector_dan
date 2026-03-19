import 'package:collector_dan/core/result.dart';
import 'package:collector_dan/features/cards/domain/entities/card_draft_suggestion.dart';
import 'package:collector_dan/features/cards/domain/entities/card_entity.dart';
import 'package:collector_dan/features/cards/domain/repositories/card_repository.dart';
import 'package:collector_dan/features/cards/domain/usecases/confirm_card_draft.dart';
import 'package:test/test.dart';

void main() {
  group('ConfirmCardDraft', () {
    test('maps a valid draft into a persisted card', () async {
      final repository = _FakeCardRepository();
      final useCase = ConfirmCardDraft(repository);

      final result = await useCase(
        cardId: 'card-1',
        draft: const CardDraftSuggestion(
          playerName: 'Ken Griffey Jr.',
          setName: 'Topps Traded',
          year: 1989,
          sourceImagePaths: ['/tmp/front.jpg', '/tmp/back.jpg'],
          isRookieCard: true,
        ),
      );

      expect(result, isA<Success<CardEntity>>());
      final card = (result as Success<CardEntity>).value;
      expect(card.id, 'card-1');
      expect(card.images.length, 2);
      expect(card.images.first.filePath, '/tmp/front.jpg');
    });

    test('fails when the draft does not contain mandatory data', () async {
      final repository = _FakeCardRepository();
      final useCase = ConfirmCardDraft(repository);

      final result = await useCase(
        cardId: 'card-1',
        draft: const CardDraftSuggestion(year: 1989),
      );

      expect(result, isA<Failure<CardEntity>>());
    });
  });
}

class _FakeCardRepository implements CardRepository {
  @override
  Future<Result<CardEntity>> createCard(CardEntity card) async => Success(card);
}
