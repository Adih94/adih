import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_belajar/app.dart';
import 'package:aplikasi_belajar/screens/splash/splash_screen.dart';
import 'package:aplikasi_belajar/screens/welcome/welcome_screen.dart';

void main() {
  testWidgets('app starts at splash then navigates to welcome',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiBelajarApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Aplikasi Belajar'), findsWidgets);

    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
