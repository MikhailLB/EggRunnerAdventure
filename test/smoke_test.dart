import 'package:egg_runner_adventure/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('boots into a MaterialApp', (tester) async {
    // No coordinator → gate skipped, boot renders the splash then the white
    // placeholder without throwing.
    await tester.pumpWidget(const FeatheredOriginsApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
