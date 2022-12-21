import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareBody', () {
    final firstFrame =
        ByteData.view(Uint8List.fromList(transparentImage).buffer);

    testWidgets(
      'renders SmallShareBody in small layout',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpApp(
          SingleChildScrollView(child: ShareBody(firstFrame: firstFrame)),
        );
        expect(find.byType(SmallShareBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareBody in large layout',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpApp(
          SingleChildScrollView(child: ShareBody(firstFrame: firstFrame)),
        );
        expect(find.byType(LargeShareBody), findsOneWidget);
      },
    );

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(child: ShareBody(firstFrame: firstFrame)),
      );
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(child: ShareBody(firstFrame: firstFrame)),
      );
      expect(
        find.byType(DownloadButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(child: ShareBody(firstFrame: firstFrame)),
      );
      expect(
        find.byType(RetakeButton),
        findsOneWidget,
      );
    });

    testWidgets(
      'RetakeButton navigates to photobooth when pressed',
      (tester) async {
        await tester.pumpApp(
          SingleChildScrollView(child: ShareBody(firstFrame: firstFrame)),
        );
        final finder = find.byType(RetakeButton);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pump(kThemeAnimationDuration);
        await tester.pump(kThemeAnimationDuration);
        expect(find.byType(PhotoBoothPage), findsOneWidget);
      },
    );
  });
}
