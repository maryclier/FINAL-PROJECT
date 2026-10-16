import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brew_and_bloom/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpFrames(WidgetTester tester) async {
  for (var frame = 0; frame < 8; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  testWidgets('Brew & Bloom opens successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BrewBloomApp());
    await tester.pumpAndSettle();

    expect(find.text('BREW & BLOOM'), findsOneWidget);
  });

  testWidgets('restores the entered login details after app restart', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BrewBloomApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Get Started'));
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Mia Santos');
    await tester.enterText(fields.at(1), 'mia@example.com');
    await tester.enterText(fields.at(2), 'coffeelover');
    await tester.tap(find.text('Enter My Cozy Space  →'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Mia! ☕'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const BrewBloomApp());
    await tester.pumpAndSettle();

    expect(find.text('Hello, Mia! ☕'), findsOneWidget);
  });

  testWidgets('restores the selected tab after app restart', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'brew_bloom_logged_in': true,
      'brew_bloom_user_name': 'Mia Santos',
      'brew_bloom_user_email': 'mia@example.com',
    });
    await tester.pumpWidget(const BrewBloomApp());
    await _pumpFrames(tester);

    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
    expect(
      (await SharedPreferences.getInstance()).getInt('brew_bloom_selected_tab'),
      3,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const BrewBloomApp());
    await _pumpFrames(tester);

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
  });
}
