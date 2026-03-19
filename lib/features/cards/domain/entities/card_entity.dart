import 'dart:collection';

import 'card_image_entity.dart';

class CardEntity {
  CardEntity({
    required this.id,
    required this.playerName,
    required this.setName,
    required this.year,
    this.teamId,
    this.brand,
    this.cardNumber,
    this.rarityId,
    this.notes,
    this.isRookieCard = false,
    this.isAutographed = false,
    this.isGraded = false,
    this.graderCompany,
    this.gradeValue,
    List<CardImageEntity> images = const [],
  }) : images = UnmodifiableListView(images);

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
  final UnmodifiableListView<CardImageEntity> images;

  CardEntity copyWith({
    String? id,
    String? playerName,
    String? setName,
    int? year,
    String? teamId,
    String? brand,
    String? cardNumber,
    String? rarityId,
    String? notes,
    bool? isRookieCard,
    bool? isAutographed,
    bool? isGraded,
    String? graderCompany,
    double? gradeValue,
    List<CardImageEntity>? images,
  }) {
    return CardEntity(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      setName: setName ?? this.setName,
      year: year ?? this.year,
      teamId: teamId ?? this.teamId,
      brand: brand ?? this.brand,
      cardNumber: cardNumber ?? this.cardNumber,
      rarityId: rarityId ?? this.rarityId,
      notes: notes ?? this.notes,
      isRookieCard: isRookieCard ?? this.isRookieCard,
      isAutographed: isAutographed ?? this.isAutographed,
      isGraded: isGraded ?? this.isGraded,
      graderCompany: graderCompany ?? this.graderCompany,
      gradeValue: gradeValue ?? this.gradeValue,
      images: images ?? this.images,
    );
  }
}
