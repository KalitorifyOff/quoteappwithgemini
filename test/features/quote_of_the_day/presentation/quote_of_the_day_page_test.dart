import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/features/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:streakdemo/features/quote_of_the_day/presentation/quote_of_the_day_page.dart';

class MockQuoteOfTheDayBloc extends Mock implements QuoteOfTheDayBloc {}

// Define a fake class for QuoteOfTheDayEvent
class FakeQuoteOfTheDayEvent extends Fake implements QuoteOfTheDayEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeQuoteOfTheDayEvent());
  });

  group('QuoteOfTheDayPage', () {
    late MockQuoteOfTheDayBloc mockQuoteOfTheDayBloc;

    setUp(() {
      mockQuoteOfTheDayBloc = MockQuoteOfTheDayBloc();
      when(() => mockQuoteOfTheDayBloc.stream).thenAnswer((_) => Stream.empty());
      when(() => mockQuoteOfTheDayBloc.state).thenReturn(QuoteOfTheDayInitial());
      when(() => mockQuoteOfTheDayBloc.close()).thenAnswer((_) async {}); // Mock close method
    });

    testWidgets('renders QuoteOfTheDayInitial', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteOfTheDayBloc>(
            create: (context) => mockQuoteOfTheDayBloc,
            child: const QuoteOfTheDayPage(),
          ),
        ),
      );

      expect(find.text('Press the button to load quote'), findsOneWidget);
    });

    testWidgets('renders QuoteOfTheDayLoading', (tester) async {
      when(() => mockQuoteOfTheDayBloc.state).thenReturn(QuoteOfTheDayLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteOfTheDayBloc>(
            create: (context) => mockQuoteOfTheDayBloc,
            child: const QuoteOfTheDayPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders QuoteOfTheDayLoaded', (tester) async {
      const testQuote = Quote(content: 'Test Quote', author: 'Test Author');
      when(() => mockQuoteOfTheDayBloc.state).thenReturn(const QuoteOfTheDayLoaded(quote: testQuote));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteOfTheDayBloc>(
            create: (context) => mockQuoteOfTheDayBloc,
            child: const QuoteOfTheDayPage(),
          ),
        ),
      );

      expect(find.text('Test Quote'), findsOneWidget);
      expect(find.text('- Test Author'), findsOneWidget);
    });

    testWidgets('renders QuoteOfTheDayError', (tester) async {
      when(() => mockQuoteOfTheDayBloc.state).thenReturn(const QuoteOfTheDayError(message: 'Error message'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteOfTheDayBloc>(
            create: (context) => mockQuoteOfTheDayBloc,
            child: const QuoteOfTheDayPage(),
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('adds GetQuoteOfTheDay event on FloatingActionButton press', (tester) async {
      when(() => mockQuoteOfTheDayBloc.state).thenReturn(QuoteOfTheDayInitial());
      // Mock the add method to avoid unexpected behavior
      when(() => mockQuoteOfTheDayBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteOfTheDayBloc>(
            create: (context) => mockQuoteOfTheDayBloc,
            child: const QuoteOfTheDayPage(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      verify(() => mockQuoteOfTheDayBloc.add(GetQuoteOfTheDay())).called(1);
    });
  });
}