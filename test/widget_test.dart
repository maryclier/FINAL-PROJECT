import 'package:flutter_test/flutter_test.dart';
import 'package:brew_and_bloom/main.dart';

void main() {
  testWidgets('Brew & Bloom opens successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BrewBloomApp());

    expect(find.text('BREW & BLOOM'), findsOneWidget);
  });
}