import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_poder_judicial/app.dart';

void main() {
  testWidgets('App arranca y muestra splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('Notificadores'), findsOneWidget);
  });
}
