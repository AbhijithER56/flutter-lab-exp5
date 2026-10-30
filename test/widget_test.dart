import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_experiment_5_navigation_and_routing/home_screen.dart';
import 'package:flutter_experiment_5_navigation_and_routing/main.dart';
import 'package:flutter_experiment_5_navigation_and_routing/second_screen.dart';
import 'package:flutter_experiment_5_navigation_and_routing/user_data_model.dart';

Future<void> fillForm(
  WidgetTester tester, {
  String name = 'John',
  String regNo = '857',
  String m1 = '78',
  String m2 = '90',
  String m3 = '80',
}) async {
  await tester.enterText(find.byKey(const Key('Student Name')), name);
  await tester.enterText(find.byKey(const Key('Registration Number')), regNo);
  await tester.enterText(find.byKey(const Key('Mark 1')), m1);
  await tester.enterText(find.byKey(const Key('Mark 2')), m2);
  await tester.enterText(find.byKey(const Key('Mark 3')), m3);
}

Future<void> submit(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('submit')));
  await tester.tap(find.byKey(const Key('submit')));
  await tester.pumpAndSettle();
}

void main() {
  group('User model', () {
    test('calculates total, average and percentage', () {
      final user = User(
        name: 'John',
        regNo: '857',
        mark1: 78,
        mark2: 90,
        mark3: 80,
      );
      expect(user.total, 248);
      expect(user.average, closeTo(82.67, 0.01));
      expect(user.percentage, closeTo(82.67, 0.01));
    });
  });

  group('Student Input Screen', () {
    testWidgets('app starts on the input screen (initialRoute "/")', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Student Input Screen'), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    testWidgets('empty fields show errors and do not navigate', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await submit(tester);

      expect(find.text('Please enter the student name.'), findsOneWidget);
      expect(
        find.text('Please enter the registration number.'),
        findsOneWidget,
      );
      expect(find.text('Please enter Mark 1.'), findsOneWidget);
      expect(find.text('Please enter Mark 2.'), findsOneWidget);
      expect(find.text('Please enter Mark 3.'), findsOneWidget);
      expect(find.byType(SecondScreen), findsNothing);
    });

    testWidgets('non-numeric and out-of-range marks are rejected', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await fillForm(tester, m1: 'abc', m2: '120', m3: '-5');
      await submit(tester);

      expect(find.text('Enter a valid number.'), findsOneWidget);
      expect(find.text('Mark 2 must be between 0 and 100.'), findsOneWidget);
      expect(find.text('Mark 3 must be between 0 and 100.'), findsOneWidget);
      expect(find.byType(SecondScreen), findsNothing);
    });

    testWidgets('invalid name and registration number are rejected', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await fillForm(tester, name: '123', regNo: 'AB 12');
      await submit(tester);

      expect(
        find.text('Name can contain only letters and spaces.'),
        findsOneWidget,
      );
      expect(
        find.text('Use letters and digits only (no spaces).'),
        findsOneWidget,
      );
      expect(find.byType(SecondScreen), findsNothing);
    });

    testWidgets('boundary marks 0 and 100 are accepted', (tester) async {
      await tester.pumpWidget(const MyApp());
      await fillForm(tester, m1: '0', m2: '100', m3: '100');
      await submit(tester);

      expect(find.byType(SecondScreen), findsOneWidget);
      expect(find.text('200 / 300'), findsOneWidget);
      expect(find.text('66.67%'), findsOneWidget);
    });
  });

  group('Navigation and data passing', () {
    testWidgets('valid data navigates to /second with all values', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await fillForm(tester, regNo: '211521243185');
      await submit(tester);

      expect(find.byType(SecondScreen), findsOneWidget);
      expect(find.text('Student Result Screen'), findsOneWidget);
      expect(find.text('Name: John'), findsOneWidget);
      expect(find.text('Reg No: 211521243185'), findsOneWidget);
      expect(find.text('78 / 100'), findsOneWidget);
      expect(find.text('90 / 100'), findsOneWidget);
      expect(find.text('80 / 100'), findsOneWidget);
      expect(find.text('248 / 300'), findsOneWidget);
      expect(find.text('82.67'), findsOneWidget);
      expect(find.text('82.67%'), findsOneWidget);
      expect(find.text('Student Details Submitted..'), findsOneWidget);

      final route = ModalRoute.of(tester.element(find.byType(SecondScreen)))!;
      expect(route.settings.name, '/second');
      expect(route.settings.arguments, isA<User>());
    });

    testWidgets('Back button pops to the input screen and keeps the form', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await fillForm(tester);
      await submit(tester);
      expect(find.byType(SecondScreen), findsOneWidget);

      // Let the "Student Details Submitted.." SnackBar close first.
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.ensureVisible(find.byKey(const Key('back')));
      await tester.tap(find.byKey(const Key('back')));
      await tester.pumpAndSettle();

      expect(find.byType(SecondScreen), findsNothing);
      expect(find.text('Student Input Screen'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('AppBar back arrow also returns to the input screen', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await fillForm(tester);
      await submit(tester);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SecondScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
