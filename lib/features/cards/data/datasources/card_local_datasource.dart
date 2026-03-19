import '../../domain/entities/card_search_filters.dart';
import '../models/card_image_record.dart';
import '../models/card_record.dart';
import '../models/stored_card_record.dart';

abstract interface class CardLocalDatasource {
  Future<StoredCardRecord> insertCard({
    required CardRecord card,
    required List<CardImageRecord> images,
  });

  Future<StoredCardRecord> updateCard({
    required CardRecord card,
    required List<CardImageRecord> images,
  });

  Future<void> deleteCard(String cardId);

  Future<StoredCardRecord?> fetchCardById(String cardId);

  Future<List<StoredCardRecord>> searchCards(CardSearchFilters filters);
}
