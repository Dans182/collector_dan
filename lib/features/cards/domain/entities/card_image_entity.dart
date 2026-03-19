enum CardImageType { front, back, detail, other }

class CardImageEntity {
  const CardImageEntity({
    required this.id,
    required this.filePath,
    required this.type,
    this.sortOrder = 0,
  });

  final String id;
  final String filePath;
  final CardImageType type;
  final int sortOrder;

  CardImageEntity copyWith({
    String? id,
    String? filePath,
    CardImageType? type,
    int? sortOrder,
  }) {
    return CardImageEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
