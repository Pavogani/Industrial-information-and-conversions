import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:industrial_info_conversions/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: IndustrialInfoApp()),
    );

    // Verify that the app loads with the conversion screen
    expect(find.text('Quick Conversion'), findsOneWidget);
  });
}
