import '../../domain/entities/card_entity.dart';
import '../../domain/entities/card_image_entity.dart';
import '../models/card_image_record.dart';
import '../models/card_record.dart';
import '../models/stored_card_record.dart';

class CardMapper {
  const CardMapper();

  CardRecord toRecord(CardEntity entity) {
    return CardRecord(
      id: entity.id,
      playerName: entity.playerName,
      setName: entity.setName,
      year: entity.year,
      teamId: entity.teamId,
      brand: entity.brand,
      cardNumber: entity.cardNumber,
      rarityId: entity.rarityId,
      notes: entity.notes,
      isRookieCard: entity.isRookieCard,
      isAutographed: entity.isAutographed,
      isGraded: entity.isGraded,
      graderCompany: entity.graderCompany,
      gradeValue: entity.gradeValue,
    );
  }

  List<CardImageRecord> toImageRecords(CardEntity entity) {
    return [
      for (final image in entity.images)
        CardImageRecord(
          id: image.id,
          cardId: entity.id,
          filePath: image.filePath,
          type: _imageTypeToValue(image.type),
          sortOrder: image.sortOrder,
        ),
    ];
  }

  CardEntity fromStoredRecord(StoredCardRecord storedRecord) {
    final card = storedRecord.card;
    return CardEntity(
      id: card.id,
      playerName: card.playerName,
      setName: card.setName,
      year: card.year,
      teamId: card.teamId,
      brand: card.brand,
      cardNumber: card.cardNumber,
      rarityId: card.rarityId,
      notes: card.notes,
      isRookieCard: card.isRookieCard,
      isAutographed: card.isAutographed,
      isGraded: card.isGraded,
      graderCompany: card.graderCompany,
      gradeValue: card.gradeValue,
      images: [
        for (final image in storedRecord.images)
          CardImageEntity(
            id: image.id,
            filePath: image.filePath,
            type: _imageTypeFromValue(image.type),
            sortOrder: image.sortOrder,
          ),
      ],
    );
  }

  String _imageTypeToValue(CardImageType type) {
    switch (type) {
      case CardImageType.front:
        return 'front';
      case CardImageType.back:
        return 'back';
      case CardImageType.detail:
        return 'detail';
      case CardImageType.other:
        return 'other';
    }
  }

  CardImageType _imageTypeFromValue(String value) {
    switch (value) {
      case 'front':
        return CardImageType.front;
      case 'back':
        return CardImageType.back;
      case 'detail':
        return CardImageType.detail;
      case 'other':
      default:
        return CardImageType.other;
    }
  }
}
