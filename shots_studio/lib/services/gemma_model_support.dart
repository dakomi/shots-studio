import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path/path.dart' as path;

class GemmaModelConfiguration {
  final String fileName;
  final ModelType modelType;
  final ModelFileType fileType;

  const GemmaModelConfiguration({
    required this.fileName,
    required this.modelType,
    required this.fileType,
  });
}

class GemmaRecommendedModel {
  final String fileName;
  final String label;
  final String size;
  final String downloadUrl;
  final String manualDownloadUrl;

  const GemmaRecommendedModel({
    required this.fileName,
    required this.label,
    required this.size,
    required this.downloadUrl,
    required this.manualDownloadUrl,
  });
}

class GemmaModelSupport {
  static const List<String> supportedFileExtensions = [
    'bin',
    'gguf',
    'task',
    'litertlm',
  ];
  static const GemmaRecommendedModel recommendedModel = GemmaRecommendedModel(
    fileName: 'gemma-4-E2B-it.litertlm',
    label: 'Gemma 4 E2B IT (.litertlm)',
    size: '~2.4GB',
    downloadUrl:
        'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm?download=true',
    manualDownloadUrl:
        'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm',
  );

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
    final extension = path.extension(lowerCaseFileName);
    final isLiteRtLm = extension == '.litertlm';
    final baseName = path.basenameWithoutExtension(lowerCaseFileName);
    final isGemma4LiteRtLm =
        isLiteRtLm && _isGemma4LiteRtLmName(baseName);
    final fileType = switch (extension) {
      '.litertlm' => ModelFileType.litertlm,
      '.bin' || '.gguf' => ModelFileType.binary,
      '.task' => ModelFileType.task,
      _ => throw ArgumentError.value(
        modelFilePath,
        'modelFilePath',
        'Unsupported Gemma model file type',
      ),
    };

    return GemmaModelConfiguration(
      fileName: fileName,
      modelType: isGemma4LiteRtLm ? ModelType.gemma4 : ModelType.gemmaIt,
      fileType: fileType,
    );
  }

  static bool _isGemma4LiteRtLmName(String baseName) {
    final tokens = baseName.split(RegExp(r'[^a-z0-9]+'));

    for (var i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      if (token == 'gemma4' || token == 'gemmav4') {
        return true;
      }

      if (token == 'gemma' &&
          i + 1 < tokens.length &&
          (tokens[i + 1] == '4' || tokens[i + 1] == 'v4')) {
        return true;
      }

      if ((token == '4' || token == 'v4') &&
          i + 1 < tokens.length &&
          tokens[i + 1] == 'gemma') {
        return true;
      }
    }

    return false;
  }
}
