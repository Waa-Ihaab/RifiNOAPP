import 'package:flutter_test/flutter_test.dart';
import 'package:rifino/app/rifino_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Rifino starts on home', (tester) async {
    SharedPreferences.setMockInitialValues({
      'rifino.onboarding.done': true,
    });

    await tester.pumpWidget(const RifinoApp());
    await tester.pumpAndSettle();

    expect(find.text('Azul, on continue ?'), findsOneWidget);
    expect(find.text('Dico'), findsOneWidget);
  });
}
