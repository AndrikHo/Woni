import 'package:flutter_test/flutter_test.dart';
import 'package:woni/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const WoniApp());
    expect(find.text('안녕하세요'), findsOneWidget);
  });
}
