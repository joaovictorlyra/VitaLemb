import 'package:flutter_test/flutter_test.dart';
import 'package:vita_lemb/main.dart';

void main() {
  testWidgets('App smoke test', (tester) async {
    await tester.pumpWidget(const VitaLembApp());
    expect(find.text('VitaLemb'), findsOneWidget);
  });
}
