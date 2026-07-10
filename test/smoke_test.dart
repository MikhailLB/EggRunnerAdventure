import 'package:egg_runner_adventure/app/app.dart';
import 'package:egg_runner_adventure/data/progress_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProgressStore.init();
  });

  testWidgets('boots into a MaterialApp with locale', (tester) async {
    await tester.pumpWidget(const FeatheredOriginsApp());
    // Boot screen paints immediately.
    expect(find.byType(MaterialApp), findsOneWidget);
    // Loading progress bar becomes visible during boot.
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
