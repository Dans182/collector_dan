import '../../../../core/result.dart';
import '../entities/card_entity.dart';

abstract interface class CardRepository {
  Future<Result<CardEntity>> createCard(CardEntity card);
}
