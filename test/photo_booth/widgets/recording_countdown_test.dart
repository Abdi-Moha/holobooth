import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAnimationController extends Mock implements AnimationController {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AudioPlayer audioPlayer;

  setUp(() {
    audioPlayer = _MockAudioPlayer();
    when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
    when(() => audioPlayer.load()).thenAnswer((_) async {
      return null;
    });
    when(() => audioPlayer.play()).thenAnswer((_) async {});
    when(() => audioPlayer.pause()).thenAnswer((_) async {});
    when(() => audioPlayer.stop()).thenAnswer((_) async {});
    when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
    when(() => audioPlayer.dispose()).thenAnswer((_) async {});
    when(() => audioPlayer.playerStateStream).thenAnswer(
      (_) => Stream.fromIterable(
        [
          PlayerState(true, ProcessingState.ready),
        ],
      ),
    );

    AudioPlayerMixin.audioPlayerOverride = audioPlayer;

    const MethodChannel('com.ryanheise.audio_session')
        .setMockMethodCallHandler((call) async {
      if (call.method == 'getConfiguration') {
        return {};
      }
    });
  });

  tearDown(() {
    AudioPlayerMixin.audioPlayerOverride = null;
  });

  group('ShutterButton', () {
    testWidgets(
      'set asset correctly',
      (WidgetTester tester) async {
        await tester.pumpApp(
          RecordingCountdown(
            onCountdownCompleted: () {},
          ),
        );
        await tester.pumpAndSettle();
        verify(() => audioPlayer.setAsset(any())).called(1);
      },
    );
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        RecordingCountdown(
          onCountdownCompleted: () {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RecordingCountdown), findsOneWidget);
    });

    testWidgets('renders CameraButton when animation has not started',
        (tester) async {
      await tester.pumpApp(
        RecordingCountdown(
          onCountdownCompleted: () {},
        ),
      );
      expect(find.byType(CountdownTimer), findsNothing);
    });
  });

  group('TimerPainter', () {
    late AnimationController animation;

    setUp(() {
      animation = _MockAnimationController();
    });

    test('verifies should not repaint', () async {
      final timePainter =
          TimerPainter(animation: animation, controllerValue: 3);
      expect(timePainter.shouldRepaint(timePainter), false);
    });
  });
}
