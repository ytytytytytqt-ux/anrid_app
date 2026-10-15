import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anroid_app/screens/home_screen.dart';

void main() {
  testWidgets('Dana Pro App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DanaProApp());

    // Verify app renders successfully.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
