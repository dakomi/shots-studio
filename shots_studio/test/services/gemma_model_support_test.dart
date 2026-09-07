import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shots_studio/services/gemma_model_support.dart';

void main() {
  group('GemmaModelSupport', () {
    test('detects Gemma 4 LiteRT-LM models', () {
      final config = GemmaModelSupport.resolve('/tmp/gemma-4-E2B-it.litertlm');

      expect(config.fileName, 'gemma-4-E2B-it.litertlm');
      expect(config.modelType, ModelType.gemma4);
      expect(config.fileType, ModelFileType.litertlm);
      expect(config.isGemma4, isTrue);
    });

    test('keeps legacy task models on the Gemma IT path', () {
      final config = GemmaModelSupport.resolve(
        '/tmp/gemma-3n-E2B-it-int4.task',
      );

      expect(config.modelType, ModelType.gemmaIt);
      expect(config.fileType, ModelFileType.task);
      expect(config.isGemma4, isFalse);
    });

    test('treats bin and gguf files as binary installs', () {
      final binConfig = GemmaModelSupport.resolve('/tmp/gemma-model.bin');
      final ggufConfig = GemmaModelSupport.resolve('/tmp/gemma-model.gguf');

      expect(binConfig.fileType, ModelFileType.binary);
      expect(ggufConfig.fileType, ModelFileType.binary);
    });

    test('validates supported file extensions', () {
      expect(
        GemmaModelSupport.isSupportedModelFile('/tmp/gemma-4-E2B-it.litertlm'),
        isTrue,
      );
      expect(
        GemmaModelSupport.isSupportedModelFile('/tmp/gemma-3n-E2B-it-int4.task'),
        isTrue,
      );
      expect(GemmaModelSupport.isSupportedModelFile('/tmp/model.exe'), isFalse);
    });
  });
}
