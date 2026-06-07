import 'package:flutter_test/flutter_test.dart';
import 'package:jewellery_erp/main.dart' as app;

void main() {
  testWidgets('shows Jewellery ERP dashboard', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Jewellery ERP'), findsOneWidget);
    expect(find.text('Stock Value'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
  });
}
