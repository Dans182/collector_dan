class OcrTextLine {
  const OcrTextLine({
    required this.text,
    this.confidence,
  });

  final String text;
  final double? confidence;
}

class OcrTextResult {
  const OcrTextResult({
    required this.rawText,
    required this.lines,
    this.averageConfidence,
  });

  final String rawText;
  final List<OcrTextLine> lines;
  final double? averageConfidence;
}
