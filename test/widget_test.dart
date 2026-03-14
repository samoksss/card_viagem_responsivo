import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:card_viagem_responsivo/main.dart';

void main() {
  testWidgets('FlutterTrips app smoke test', (WidgetTester tester) async {
    // Silencia erros de asset não encontrado (esperado em ambiente de teste)
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.toString().contains('asset')) return;
      originalOnError?.call(details);
    };

    // Sobe o app
    await tester.pumpWidget(const FlutterTripsApp());

    // Deixa o widget tree assentar (resolve frames pendentes, animações, etc.)
    await tester.pumpAndSettle();

    // Verifica que a AppBar com o título foi renderizada
    expect(find.text('✈️ FlutterTrips'), findsOneWidget);

    // Verifica que pelo menos um card de destino aparece
    expect(find.text('Santorini'), findsOneWidget);

    // Restaura o handler original
    FlutterError.onError = originalOnError;
  });
}