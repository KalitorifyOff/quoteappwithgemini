import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/user_streak.dart';
import 'package:streakdemo/features/streak_management/bloc/streak_bloc.dart';
import 'package:streakdemo/features/streak_management/presentation/streak_display_page.dart';

class MockStreakBloc extends MockBloc<StreakEvent, StreakState>
    implements StreakBloc {}

void main() {
  group('StreakDisplayPage', () {
    late MockStreakBloc mockStreakBloc;

    setUp(() {
      mockStreakBloc = MockStreakBloc();
    });

    testWidgets('renders CircularProgressIndicator when StreakLoading', (tester) async {
      when(() => mockStreakBloc.state).thenReturn(StreakLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StreakBloc>.value(
            value: mockStreakBloc,
            child: const StreakDisplayPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders "Start a new streak today!" when StreakLoaded with no streak', (tester) async {
      when(() => mockStreakBloc.state).thenReturn(const StreakLoaded(streak: null));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StreakBloc>.value(
            value: mockStreakBloc,
            child: const StreakDisplayPage(),
          ),
        ),
      );

      expect(find.text('Start a new streak today!'), findsOneWidget);
    });

    testWidgets('renders streak count and last accessed date when StreakLoaded with a streak', (tester) async {
      final testStreak = UserStreak(id: 1, lastAccessed: DateTime(2025, 7, 31), streakCount: 5);
      when(() => mockStreakBloc.state).thenReturn(StreakLoaded(streak: testStreak));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StreakBloc>.value(
            value: mockStreakBloc,
            child: const StreakDisplayPage(),
          ),
        ),
      );

      expect(find.text('Current Streak:'), findsOneWidget);
      expect(find.text('5 days'), findsOneWidget);
      expect(find.text('Last accessed: 2025-07-31'), findsOneWidget);
      expect(find.text('Update Streak'), findsOneWidget);
    });

    testWidgets('dispatches UpdateStreak event when Update Streak button is pressed', (tester) async {
      final testStreak = UserStreak(id: 1, lastAccessed: DateTime(2025, 7, 31), streakCount: 5);
      when(() => mockStreakBloc.state).thenReturn(StreakLoaded(streak: testStreak));
      when(() => mockStreakBloc.add(UpdateStreak())).thenReturn(null); // Mock the add method

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StreakBloc>.value(
            value: mockStreakBloc,
            child: const StreakDisplayPage(),
          ),
        ),
      );

      await tester.tap(find.text('Update Streak'));
      await tester.pump();

      verify(() => mockStreakBloc.add(UpdateStreak())).called(1);
    });

    testWidgets('renders error message when StreakError', (tester) async {
      when(() => mockStreakBloc.state).thenReturn(const StreakError(message: 'Failed to load streak'));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StreakBloc>.value(
            value: mockStreakBloc,
            child: const StreakDisplayPage(),
          ),
        ),
      );

      expect(find.text('Error: Failed to load streak'), findsOneWidget);
    });
  });
}
