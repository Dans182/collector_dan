import '../../../../core/result.dart';
import '../entities/card_entity.dart';
import '../entities/card_search_filters.dart';

abstract interface class CardRepository {
  Future<Result<CardEntity>> createCard(CardEntity card);

  Future<Result<CardEntity>> updateCard(CardEntity card);

  Future<Result<void>> deleteCard(String cardId);

  Future<Result<CardEntity>> getCardById(String cardId);

  Future<Result<List<CardEntity>>> searchCards(CardSearchFilters filters);
}
