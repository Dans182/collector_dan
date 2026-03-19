import '../../../../core/result.dart';
import '../entities/ocr_text_result.dart';
import '../repositories/ocr_repository.dart';

class ExtractTextFromCardImage {
  const ExtractTextFromCardImage(this._ocrRepository);

  final OcrRepository _ocrRepository;

  Future<Result<OcrTextResult>> call(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return Future.value(const Failure('The image path cannot be empty.'));
    }

    return _ocrRepository.extractTextFromImage(imagePath);
  }
}
