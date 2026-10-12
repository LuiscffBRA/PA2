import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/feed/widgets/in_app_map_modal.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('In-App Map Modal (OpenStreetMap)', () {
    testWidgets('Deve renderizar o cabeçalho e controles do mapa no modal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InAppMapModal(
              title: 'Pastelaria da Maria',
              referencePoint: 'Ao lado da estação Sé',
              initialLocation: LatLng(-23.55052, -46.63330),
            ),
          ),
        ),
      );

      // Verifica se o título e o ponto de referência aparecem
      expect(find.text('Pastelaria da Maria'), findsWidgets);
      expect(find.text('Ao lado da estação Sé'), findsOneWidget);

      // Verifica se os botões de controle de zoom e recentralizar existem
      expect(find.byIcon(Icons.my_location), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);

      // Verifica o botão de rota no Google Maps
      expect(find.text('Rota no Google Maps'), findsOneWidget);
    });
  });
}
