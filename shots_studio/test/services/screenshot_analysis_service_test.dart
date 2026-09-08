import 'package:flutter_test/flutter_test.dart';
import 'package:shots_studio/models/screenshot_model.dart';
import 'package:shots_studio/services/ai_service.dart';
import 'package:shots_studio/services/screenshot_analysis_service.dart';

void main() {
  group('ScreenshotAnalysisService', () {
    late ScreenshotAnalysisService service;

    setUp(() {
      service = ScreenshotAnalysisService(
        const AIConfig(apiKey: '', modelName: 'gemma-4', maxParallel: 2),
      );
    });

    Screenshot buildScreenshot(String id) {
      return Screenshot(
        id: id,
        title: '$id.png',
        addedOn: DateTime(2026),
        tags: const [],
        aiProcessed: false,
      );
    }

    test('returns no updates when provider returns an error response', () {
      final screenshots = [buildScreenshot('one')];

      final updated = service.parseAndUpdateScreenshots(screenshots, {
        'error': 'Gemma model could not be loaded',
        'statusCode': 400,
      });

      expect(updated, isEmpty);
    });

    test('returns no updates for invalid JSON payloads', () {
      final screenshots = [buildScreenshot('one')];

      final updated = service.parseAndUpdateScreenshots(screenshots, {
        'data': 'not json',
        'statusCode': 200,
      });

      expect(updated, isEmpty);
    });

    test('only returns screenshots that were actually matched and updated', () {
      final first = buildScreenshot('first.png');
      final second = buildScreenshot('second.png');

      final updated = service.parseAndUpdateScreenshots([
        first,
        second,
      ], {
        'data':
            '[{"filename":"first.png","title":"Updated title","desc":"Updated desc","tags":["tag1"],"links":[],"collections":[]}]',
        'statusCode': 200,
      });

      expect(updated, hasLength(1));
      expect(updated.single.id, first.id);
      expect(updated.single.title, 'Updated title');
      expect(updated.single.description, 'Updated desc');
      expect(updated.single.tags, ['tag1']);
      expect(updated.single.aiProcessed, isTrue);
    });
  });
}
