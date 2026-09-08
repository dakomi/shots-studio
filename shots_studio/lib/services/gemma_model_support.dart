import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path/path.dart' as path;

class GemmaModelConfiguration {
  final String fileName;
  final ModelType modelType;
  final ModelFileType fileType;
  final bool isGemma4;

  const GemmaModelConfiguration({
    required this.fileName,
    required this.modelType,
    required this.fileType,
    required this.isGemma4,
  });
}

class GemmaModelSupport {
  static const List<String> supportedFileExtensions = [
    'bin',
    'gguf',
    'task',
    'litertlm',
  ];
  static const String recommendedModelFileName = 'gemma-4-E2B-it.litertlm';
  static const String recommendedModelLabel = 'Gemma 4 E2B IT (.litertlm)';
  static const String recommendedModelSize = '~2.4GB';
  static const String recommendedDownloadUrl =
      'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm?download=true';
  static const String manualDownloadUrl =
      'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm';

  static bool isSupportedModelFile(String modelFilePath) {
    final extension = path.extension(modelFilePath).toLowerCase();
    if (extension.isEmpty) {
      return false;
    }

    return supportedFileExtensions.contains(extension.substring(1));
  }

  static GemmaModelConfiguration resolve(String modelFilePath) {
    final fileName = path.basename(modelFilePath);
    final lowerCaseFileName = fileName.toLowerCase();
    final isGemma4 =
        lowerCaseFileName.contains('gemma-4') ||
        lowerCaseFileName.contains('gemma_4') ||
        lowerCaseFileName.contains('gemma4');
    final isLiteRtLm = lowerCaseFileName.endsWith('.litertlm');
    final isBinaryLike =
        lowerCaseFileName.endsWith('.bin') ||
        lowerCaseFileName.endsWith('.gguf') ||
        lowerCaseFileName.endsWith('.tflite');

    return GemmaModelConfiguration(
      fileName: fileName,
      modelType: isGemma4 ? ModelType.gemma4 : ModelType.gemmaIt,
      fileType:
          isLiteRtLm
              ? ModelFileType.litertlm
              : isBinaryLike
              ? ModelFileType.binary
              : ModelFileType.task,
      isGemma4: isGemma4,
    );
  }
}
