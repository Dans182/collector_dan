import '../../../../core/result.dart';
import '../entities/card_draft_suggestion.dart';
import '../entities/card_entity.dart';
import '../entities/card_image_entity.dart';
import '../repositories/card_repository.dart';

class ConfirmCardDraft {
  const ConfirmCardDraft(this._cardRepository);

  final CardRepository _cardRepository;

  Future<Result<CardEntity>> call({
    required String cardId,
    required CardDraftSuggestion draft,
  }) {
    final validationError = _validateDraft(draft);
    if (validationError != null) {
      return Future.value(Failure(validationError));
    }

    final card = CardEntity(
      id: cardId,
      playerName: draft.playerName!.trim(),
      setName: draft.setName!.trim(),
      year: draft.year!,
      teamId: draft.teamId,
      brand: draft.brand,
      cardNumber: draft.cardNumber,
      rarityId: draft.rarityId,
      notes: draft.notes,
      isRookieCard: draft.isRookieCard ?? false,
      isAutographed: draft.isAutographed ?? false,
      isGraded: draft.isGraded ?? false,
      graderCompany: draft.graderCompany,
      gradeValue: draft.gradeValue,
      images: draft.images.isEmpty ? _buildImagesFromPaths(draft.sourceImagePaths) : draft.images,
    );

    return _cardRepository.createCard(card);
  }

  String? _validateDraft(CardDraftSuggestion draft) {
    if (draft.playerName == null || draft.playerName!.trim().isEmpty) {
      return 'Player name is required before confirming the draft.';
    }
    if (draft.setName == null || draft.setName!.trim().isEmpty) {
      return 'Set name is required before confirming the draft.';
    }
    if (draft.year == null) {
      return 'Year is required before confirming the draft.';
    }
    if ((draft.isGraded ?? false) &&
        (draft.graderCompany == null || draft.graderCompany!.trim().isEmpty || draft.gradeValue == null)) {
      return 'Graded cards require grader company and grade value.';
    }
    return null;
  }

  List<CardImageEntity> _buildImagesFromPaths(List<String> paths) {
    return [
      for (var i = 0; i < paths.length; i++)
        CardImageEntity(
          id: 'image-$i',
          filePath: paths[i],
          type: i == 0 ? CardImageType.front : CardImageType.back,
          sortOrder: i,
        ),
    ];
  }
}
