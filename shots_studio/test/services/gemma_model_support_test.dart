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
    });

    test('detects Gemma 4 LiteRT-LM naming variants', () {
      final underscoreConfig = GemmaModelSupport.resolve(
        '/tmp/gemma_4_E2B_it.litertlm',
      );
      final compactConfig = GemmaModelSupport.resolve(
        '/tmp/gemma4-e2b-it.litertlm',
      );
      final dottedConfig = GemmaModelSupport.resolve(
        '/tmp/gemma.4.e2b.it.litertlm',
      );
      final versionedConfig = GemmaModelSupport.resolve(
        '/tmp/gemma-v4-e2b-it.litertlm',
      );
      final prefixedConfig = GemmaModelSupport.resolve(
        '/tmp/google_gemma-4-E2B-it.litertlm',
      );
      final reversedOrderConfig = GemmaModelSupport.resolve(
        '/tmp/google_4_gemma_e2b_it.litertlm',
      );
      final attachedVersionConfig = GemmaModelSupport.resolve(
        '/tmp/google_gemmav4_e2b_it.litertlm',
      );

      expect(underscoreConfig.modelType, ModelType.gemma4);
      expect(compactConfig.modelType, ModelType.gemma4);
      expect(dottedConfig.modelType, ModelType.gemma4);
      expect(versionedConfig.modelType, ModelType.gemma4);
      expect(prefixedConfig.modelType, ModelType.gemma4);
      expect(reversedOrderConfig.modelType, ModelType.gemma4);
      expect(attachedVersionConfig.modelType, ModelType.gemma4);
    });

    test('keeps legacy task models on the Gemma IT path', () {
      final config = GemmaModelSupport.resolve(
        '/tmp/gemma-3n-E2B-it-int4.task',
      );
      expect(config.modelType, ModelType.gemmaIt);
      expect(config.fileType, ModelFileType.task);
    });

    test('keeps non-Gemma-4 LiteRT-LM models on the Gemma IT path', () {
      final config = GemmaModelSupport.resolve(
        '/tmp/gemma-3n-E2B-it-int4.litertlm',
      );
      final genericConfig = GemmaModelSupport.resolve('/tmp/model.litertlm');

      expect(config.modelType, ModelType.gemmaIt);
      expect(config.fileType, ModelFileType.litertlm);
      expect(genericConfig.modelType, ModelType.gemmaIt);
      expect(genericConfig.fileType, ModelFileType.litertlm);
    });

    test('treats bin and gguf files as binary installs', () {
      final binConfig = GemmaModelSupport.resolve('/tmp/gemma-model.bin');
      final ggufConfig = GemmaModelSupport.resolve('/tmp/gemma-model.gguf');

      expect(binConfig.modelType, ModelType.gemmaIt);
      expect(ggufConfig.modelType, ModelType.gemmaIt);
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

    test('rejects unsupported extensions during resolution', () {
      expect(
        () => GemmaModelSupport.resolve('/tmp/model.exe'),
        throwsArgumentError,
      );
    });

    test('does not treat larger tokens containing gemma4 as Gemma 4', () {
      final config = GemmaModelSupport.resolve(
        '/tmp/notgemma4compatible.litertlm',
      );

      expect(config.modelType, ModelType.gemmaIt);
      expect(config.fileType, ModelFileType.litertlm);
    });

    test('does not treat Gemma 4B filenames as Gemma 4', () {
      final config = GemmaModelSupport.resolve('/tmp/gemma-4b-it.litertlm');

      expect(config.modelType, ModelType.gemmaIt);
      expect(config.fileType, ModelFileType.litertlm);
    });
  });
}
