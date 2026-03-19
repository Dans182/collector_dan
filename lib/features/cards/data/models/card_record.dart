class CardRecord {
  const CardRecord({
    required this.id,
    required this.playerName,
    required this.setName,
    required this.year,
    this.teamId,
    this.brand,
    this.cardNumber,
    this.rarityId,
    this.notes,
    required this.isRookieCard,
    required this.isAutographed,
    required this.isGraded,
    this.graderCompany,
    this.gradeValue,
  });

  final String id;
  final String playerName;
  final String setName;
  final int year;
  final String? teamId;
  final String? brand;
  final String? cardNumber;
  final String? rarityId;
  final String? notes;
  final bool isRookieCard;
  final bool isAutographed;
  final bool isGraded;
  final String? graderCompany;
  final double? gradeValue;
}
