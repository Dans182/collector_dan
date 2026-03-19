import '../../../../core/result.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/entities/card_search_filters.dart';
import '../../domain/repositories/card_repository.dart';
import '../datasources/card_local_datasource.dart';
import '../mappers/card_mapper.dart';

class CardRepositoryImpl implements CardRepository {
  CardRepositoryImpl({
    required CardLocalDatasource localDatasource,
    CardMapper mapper = const CardMapper(),
  })  : _localDatasource = localDatasource,
        _mapper = mapper;

  final CardLocalDatasource _localDatasource;
  final CardMapper _mapper;

  @override
  Future<Result<CardEntity>> createCard(CardEntity card) async {
    try {
      final storedRecord = await _localDatasource.insertCard(
        card: _mapper.toRecord(card),
        images: _mapper.toImageRecords(card),
      );
      return Success(_mapper.fromStoredRecord(storedRecord));
    } catch (error) {
      return Failure('Unable to create card: $error');
    }
  }

  @override
  Future<Result<void>> deleteCard(String cardId) async {
    if (cardId.trim().isEmpty) {
      return const Failure('Card id cannot be empty.');
    }

    try {
      await _localDatasource.deleteCard(cardId.trim());
      return const Success<void>(null);
    } catch (error) {
      return Failure('Unable to delete card: $error');
    }
  }

  @override
  Future<Result<CardEntity>> getCardById(String cardId) async {
    if (cardId.trim().isEmpty) {
      return const Failure('Card id cannot be empty.');
    }

    try {
      final storedRecord = await _localDatasource.fetchCardById(cardId.trim());
      if (storedRecord == null) {
        return const Failure('Card not found.');
      }
      return Success(_mapper.fromStoredRecord(storedRecord));
    } catch (error) {
      return Failure('Unable to load card: $error');
    }
  }

  @override
  Future<Result<List<CardEntity>>> searchCards(CardSearchFilters filters) async {
    try {
      final records = await _localDatasource.searchCards(filters);
      return Success([for (final record in records) _mapper.fromStoredRecord(record)]);
    } catch (error) {
      return Failure('Unable to search cards: $error');
    }
  }

  @override
  Future<Result<CardEntity>> updateCard(CardEntity card) async {
    try {
      final storedRecord = await _localDatasource.updateCard(
        card: _mapper.toRecord(card),
        images: _mapper.toImageRecords(card),
      );
      return Success(_mapper.fromStoredRecord(storedRecord));
    } catch (error) {
      return Failure('Unable to update card: $error');
    }
  }
}
