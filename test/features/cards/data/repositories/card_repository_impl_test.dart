import 'package:collector_dan/core/result.dart';
import 'package:collector_dan/features/cards/data/datasources/card_local_datasource.dart';
import 'package:collector_dan/features/cards/data/models/card_image_record.dart';
import 'package:collector_dan/features/cards/data/models/card_record.dart';
import 'package:collector_dan/features/cards/data/models/stored_card_record.dart';
import 'package:collector_dan/features/cards/data/repositories/card_repository_impl.dart';
import 'package:collector_dan/features/cards/domain/entities/card_entity.dart';
import 'package:collector_dan/features/cards/domain/entities/card_image_entity.dart';
import 'package:collector_dan/features/cards/domain/entities/card_search_filters.dart';
import 'package:test/test.dart';

void main() {
  group('CardRepositoryImpl', () {
    test('creates and fetches a card through the local datasource', () async {
      final datasource = _InMemoryDatasource();
      final repository = CardRepositoryImpl(localDatasource: datasource);
      final card = CardEntity(
        id: 'card-1',
        playerName: 'Ken Griffey Jr.',
        setName: 'Topps Traded',
        year: 1989,
        images: const [
          CardImageEntity(
            id: 'img-1',
            filePath: '/tmp/front.jpg',
            type: CardImageType.front,
          ),
        ],
      );

      final created = await repository.createCard(card);
      final fetched = await repository.getCardById('card-1');

      expect(created, isA<Success<CardEntity>>());
      expect(fetched, isA<Success<CardEntity>>());
      expect((fetched as Success<CardEntity>).value.playerName, 'Ken Griffey Jr.');
    });

    test('returns failure when card id is empty on delete', () async {
      final datasource = _InMemoryDatasource();
      final repository = CardRepositoryImpl(localDatasource: datasource);

      final result = await repository.deleteCard(' ');

      expect(result, isA<Failure<void>>());
    });

    test('searches cards using filters', () async {
      final datasource = _InMemoryDatasource(
        initialData: [
          const StoredCardRecord(
            card: CardRecord(
              id: 'card-1',
              playerName: 'Ken Griffey Jr.',
              setName: 'Topps Traded',
              year: 1989,
              teamId: 'SEA',
              isRookieCard: true,
              isAutographed: false,
              isGraded: false,
            ),
            images: [],
          ),
        ],
      );
      final repository = CardRepositoryImpl(localDatasource: datasource);

      final result = await repository.searchCards(const CardSearchFilters(teamId: 'SEA'));

      expect(result, isA<Success<List<CardEntity>>>());
      expect((result as Success<List<CardEntity>>).value, hasLength(1));
    });
  });
}

class _InMemoryDatasource implements CardLocalDatasource {
  _InMemoryDatasource({
    List<StoredCardRecord> initialData = const [],
  }) : _storage = {for (final record in initialData) record.card.id: record};

  final Map<String, StoredCardRecord> _storage;

  @override
  Future<void> deleteCard(String cardId) async {
    _storage.remove(cardId);
  }

  @override
  Future<StoredCardRecord?> fetchCardById(String cardId) async => _storage[cardId];

  @override
  Future<StoredCardRecord> insertCard({required CardRecord card, required List<CardImageRecord> images}) async {
    final stored = StoredCardRecord(card: card, images: images);
    _storage[card.id] = stored;
    return stored;
  }

  @override
  Future<List<StoredCardRecord>> searchCards(CardSearchFilters filters) async {
    return _storage.values.where((record) {
      if (filters.teamId != null && filters.teamId != record.card.teamId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<StoredCardRecord> updateCard({required CardRecord card, required List<CardImageRecord> images}) async {
    final stored = StoredCardRecord(card: card, images: images);
    _storage[card.id] = stored;
    return stored;
  }
}
