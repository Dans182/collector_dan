enum CardScanSide { front, back }

class CardScanImage {
  const CardScanImage({
    required this.path,
    required this.side,
  });

  final String path;
  final CardScanSide side;

  CardScanImage copyWith({
    String? path,
    CardScanSide? side,
  }) {
    return CardScanImage(
      path: path ?? this.path,
      side: side ?? this.side,
    );
  }
}
