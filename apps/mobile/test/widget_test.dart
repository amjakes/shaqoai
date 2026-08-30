import 'package:flutter_test/flutter_test.dart';
import 'package:shaqoai_mobile/main.dart';

void main() {
  testWidgets('renders the ShaqoAI workspace', (tester) async {
    await tester.pumpWidget(const ShaqoAiApp());
    expect(find.text('ShaqoAI'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
