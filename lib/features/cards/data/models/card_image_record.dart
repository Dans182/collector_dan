class CardImageRecord {
  const CardImageRecord({
    required this.id,
    required this.cardId,
    required this.filePath,
    required this.type,
    required this.sortOrder,
  });

  final String id;
  final String cardId;
  final String filePath;
  final String type;
  final int sortOrder;
}
