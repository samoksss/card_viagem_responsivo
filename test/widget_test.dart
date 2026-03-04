import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:card_viagem_responsivo/main.dart';

void main() {
  testWidgets('FlutterTrips app smoke test', (WidgetTester tester) async {
    // Sobe o app
    await tester.pumpWidget(const FlutterTripsApp());

    // Verifica que a AppBar com o título foi renderizada
    expect(find.text('✈️ FlutterTrips'), findsOneWidget);

    // Verifica que pelo menos um card de destino aparece
    expect(find.text('Santorini'), findsOneWidget);
  });
}