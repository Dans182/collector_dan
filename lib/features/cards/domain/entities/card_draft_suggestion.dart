import 'card_image_entity.dart';

class CardDraftSuggestion {
  const CardDraftSuggestion({
    this.playerName,
    this.year,
    this.teamId,
    this.teamName,
    this.setName,
    this.brand,
    this.cardNumber,
    this.rarityId,
    this.rarityLabel,
    this.notes,
    this.isRookieCard,
    this.isAutographed,
    this.isGraded,
    this.graderCompany,
    this.gradeValue,
    this.images = const [],
    this.sourceImagePaths = const [],
    this.rawExtractedText = '',
    this.overallConfidence = 0,
    this.fieldConfidence = const {},
  });

  final String? playerName;
  final int? year;
  final String? teamId;
  final String? teamName;
  final String? setName;
  final String? brand;
  final String? cardNumber;
  final String? rarityId;
  final String? rarityLabel;
  final String? notes;
  final bool? isRookieCard;
  final bool? isAutographed;
  final bool? isGraded;
  final String? graderCompany;
  final double? gradeValue;
  final List<CardImageEntity> images;
  final List<String> sourceImagePaths;
  final String rawExtractedText;
  final double overallConfidence;
  final Map<String, double> fieldConfidence;

  CardDraftSuggestion copyWith({
    String? playerName,
    int? year,
    String? teamId,
    String? teamName,
    String? setName,
    String? brand,
    String? cardNumber,
    String? rarityId,
    String? rarityLabel,
    String? notes,
    bool? isRookieCard,
    bool? isAutographed,
    bool? isGraded,
    String? graderCompany,
    double? gradeValue,
    List<CardImageEntity>? images,
    List<String>? sourceImagePaths,
    String? rawExtractedText,
    double? overallConfidence,
    Map<String, double>? fieldConfidence,
  }) {
    return CardDraftSuggestion(
      playerName: playerName ?? this.playerName,
      year: year ?? this.year,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      setName: setName ?? this.setName,
      brand: brand ?? this.brand,
      cardNumber: cardNumber ?? this.cardNumber,
      rarityId: rarityId ?? this.rarityId,
      rarityLabel: rarityLabel ?? this.rarityLabel,
      notes: notes ?? this.notes,
      isRookieCard: isRookieCard ?? this.isRookieCard,
      isAutographed: isAutographed ?? this.isAutographed,
      isGraded: isGraded ?? this.isGraded,
      graderCompany: graderCompany ?? this.graderCompany,
      gradeValue: gradeValue ?? this.gradeValue,
      images: images ?? this.images,
      sourceImagePaths: sourceImagePaths ?? this.sourceImagePaths,
      rawExtractedText: rawExtractedText ?? this.rawExtractedText,
      overallConfidence: overallConfidence ?? this.overallConfidence,
      fieldConfidence: fieldConfidence ?? this.fieldConfidence,
    );
  }

  bool get hasMinimumViableData =>
      (playerName?.trim().isNotEmpty ?? false) && year != null && (setName?.trim().isNotEmpty ?? false);
}
