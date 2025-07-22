// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:quality_fruit_app/main.dart';

void main() {
  testWidgets('QualityFruit App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QualityFruitApp());

    // Verify that the app title is present.
    expect(find.text('QualityFruit App'), findsOneWidget);

    // Verify that the welcome message is present.
    expect(find.text('Bem-vindo ao QualityFruit App'), findsOneWidget);

    // Verify that the evaluate button is present.
    expect(find.text('Avaliar Fruta'), findsOneWidget);

    // Verify that the history button is present.
    expect(find.text('Ver Histórico'), findsOneWidget);

    // Tap the 'Avaliar Fruta' button and verify snackbar appears.
    await tester.tap(find.text('Avaliar Fruta'));
    await tester.pump();

    // Wait for snackbar animation
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the development message appears.
    expect(find.text('Funcionalidade em desenvolvimento!'), findsOneWidget);
  });
}
