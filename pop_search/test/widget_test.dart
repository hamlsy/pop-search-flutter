// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pop_search/app/app.dart';

void main() {
  testWidgets('app boots with MVP placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const PopSearchApp());

    expect(find.text('PopSearch'), findsOneWidget);
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
