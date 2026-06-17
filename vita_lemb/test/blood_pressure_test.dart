import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vita_lemb/theme/app_theme.dart';
import 'package:vita_lemb/screens/blood_pressure/blood_pressure_screen.dart';

void main() {
  Widget wrap() => MaterialApp(theme: AppTheme.theme, home: const BloodPressureScreen());

  testWidgets('salvar registra a medição na lista de Medições', (tester) async {
    await tester.pumpWidget(wrap());

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '150'); // sistólica
    await tester.enterText(fields.at(1), '95'); // diastólica

    await tester.tap(find.text('Salvar Medição'));
    await tester.pump(); // dispara o rebuild
    await tester.pump(const Duration(seconds: 4)); // deixa o SnackBar sumir

    // A medição 150/95 deve aparecer na lista (e o SnackBar já sumiu).
    expect(find.text('150/95'), findsOneWidget);
  });

  testWidgets('limpar esvazia os campos de entrada', (tester) async {
    await tester.pumpWidget(wrap());

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '180');
    await tester.enterText(fields.at(1), '110');
    await tester.pump();
    expect(find.text('180'), findsOneWidget);

    await tester.tap(find.text('Limpar'));
    await tester.pump();

    // Os campos devem estar vazios após limpar.
    expect(find.text('180'), findsNothing);
    expect(find.text('110'), findsNothing);
  });
}
