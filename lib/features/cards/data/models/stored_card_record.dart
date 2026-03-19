import 'card_image_record.dart';
import 'card_record.dart';

class StoredCardRecord {
  const StoredCardRecord({
    required this.card,
    required this.images,
  });

  final CardRecord card;
  final List<CardImageRecord> images;
}
