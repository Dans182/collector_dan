import 'package:collector_dan/features/cards/data/mappers/card_mapper.dart';
import 'package:collector_dan/features/cards/data/models/card_image_record.dart';
import 'package:collector_dan/features/cards/data/models/card_record.dart';
import 'package:collector_dan/features/cards/data/models/stored_card_record.dart';
import 'package:collector_dan/features/cards/domain/entities/card_entity.dart';
import 'package:collector_dan/features/cards/domain/entities/card_image_entity.dart';
import 'package:test/test.dart';

void main() {
  test('maps stored records into a card entity', () {
    const mapper = CardMapper();

    final entity = mapper.fromStoredRecord(
      const StoredCardRecord(
        card: CardRecord(
          id: 'card-1',
          playerName: 'Ken Griffey Jr.',
          setName: 'Topps Traded',
          year: 1989,
          brand: 'Topps',
          cardNumber: '41T',
          rarityId: 'rookie',
          notes: 'Iconic rookie card',
          isRookieCard: true,
          isAutographed: false,
          isGraded: false,
        ),
        images: [
          CardImageRecord(
            id: 'img-1',
            cardId: 'card-1',
            filePath: '/tmp/front.jpg',
            type: 'front',
            sortOrder: 0,
          ),
        ],
      ),
    );

    expect(entity.id, 'card-1');
    expect(entity.images.first.type, CardImageType.front);
  });

  test('maps card entities into image records', () {
    const mapper = CardMapper();
    final entity = CardEntity(
      id: 'card-1',
      playerName: 'Ken Griffey Jr.',
      setName: 'Topps Traded',
      year: 1989,
      images: const [
        CardImageEntity(
          id: 'img-1',
          filePath: '/tmp/back.jpg',
          type: CardImageType.back,
          sortOrder: 1,
        ),
      ],
    );

    final imageRecords = mapper.toImageRecords(entity);

    expect(imageRecords.first.type, 'back');
    expect(imageRecords.first.cardId, 'card-1');
  });
}
