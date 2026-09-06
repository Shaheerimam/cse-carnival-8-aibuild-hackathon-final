import 'package:flutter_test/flutter_test.dart';
import 'package:profmate/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExamAuditorApp());
    expect(find.text('ExamAuditor'), findsWidgets);
  });
}
