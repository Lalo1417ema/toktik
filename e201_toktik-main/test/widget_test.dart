import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e201_toktik/main.dart';

void main() {
  testWidgets('App initializes and loads TokTik screen', (WidgetTester tester) async {
    // Construye nuestra app (MainApp) y dispara un frame.
    await tester.pumpWidget(const MainApp());

    // Como el proveedor de TokTik carga datos de manera asíncrona (loadNextPage),
    // permitimos que los frames avancen para que se renderice la interfaz.
    await tester.pump();

    // Verifica que la aplicación cargue correctamente el contenedor principal (MaterialApp).
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}