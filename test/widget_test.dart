import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:erp_fi/app.dart';

void main() {
  testWidgets('login page renders Francis Interior branding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FrancisInteriorApp());

    expect(find.text('Francis Interior ERP'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('admin login opens dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const FrancisInteriorApp());

    await tester.enterText(find.byType(TextField).first, 'admin');
    await tester.enterText(find.byType(TextField).last, 'admin');
    await tester.ensureVisible(find.text('Login'));
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Logged in locally as admin.'), findsOneWidget);
  });
}
