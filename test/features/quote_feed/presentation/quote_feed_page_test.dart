import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/features/quote_feed/bloc/quote_feed_bloc.dart';
import 'package:streakdemo/features/quote_feed/presentation/quote_feed_page.dart';

class MockQuoteFeedBloc extends Mock implements QuoteFeedBloc {}

// Define a fake class for QuoteFeedEvent
class FakeQuoteFeedEvent extends Fake implements QuoteFeedEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeQuoteFeedEvent());
  });

  group('QuoteFeedPage', () {
    late MockQuoteFeedBloc mockQuoteFeedBloc;

    setUp(() {
      mockQuoteFeedBloc = MockQuoteFeedBloc();
      when(() => mockQuoteFeedBloc.stream).thenAnswer((_) => Stream.empty());
      when(() => mockQuoteFeedBloc.state).thenReturn(QuoteFeedInitial());
      when(() => mockQuoteFeedBloc.close()).thenAnswer((_) async {});
      when(() => mockQuoteFeedBloc.add(any())).thenReturn(null); // Mock add method
    });

    testWidgets('renders QuoteFeedInitial and loads quotes', (tester) async {
      final quotes = [
        const Quote(content: 'Quote 1', author: 'Author 1'),
      ];

      // Set the initial state of the mock BLoC to loading
      when(() => mockQuoteFeedBloc.state).thenReturn(QuoteFeedLoading());

      // Set up the stream to emit loaded state after loading
      whenListen(
        mockQuoteFeedBloc,
        Stream.fromIterable([
          QuoteFeedLoaded(quotes: quotes),
        ]),
        initialState: QuoteFeedLoading(), // This is the state after initState dispatches LoadQuotes
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteFeedBloc>(
            create: (context) => mockQuoteFeedBloc,
            child: const QuoteFeedPage(),
          ),
        ),
      );

      // After the first pump, the widget should be in the loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump until all animations and rebuilds are complete (i.e., loaded state)
      await tester.pumpAndSettle();

      // Now it should be loaded
      expect(find.text('Quote 1'), findsOneWidget);
      expect(find.text('- Author 1'), findsOneWidget);
      verify(() => mockQuoteFeedBloc.add(LoadQuotes())).called(1);
    });

    testWidgets('renders QuoteFeedLoading', (tester) async {
      whenListen(
        mockQuoteFeedBloc,
        Stream.fromIterable([
          QuoteFeedLoading(),
        ]),
        initialState: QuoteFeedInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteFeedBloc>(
            create: (context) => mockQuoteFeedBloc,
            child: const QuoteFeedPage(),
          ),
        ),
      );
      await tester.pump(); // Pump to allow the CircularProgressIndicator to render

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders QuoteFeedLoaded with quotes', (tester) async {
      final quotes = [
        const Quote(content: 'Quote 1', author: 'Author 1'),
        const Quote(content: 'Quote 2', author: 'Author 2'),
      ];
      whenListen(
        mockQuoteFeedBloc,
        Stream.fromIterable([
          QuoteFeedLoaded(quotes: quotes),
        ]),
        initialState: QuoteFeedInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteFeedBloc>(
            create: (context) => mockQuoteFeedBloc,
            child: const QuoteFeedPage(),
          ),
        ),
      );
      await tester.pumpAndSettle(); // Ensure all animations and rebuilds are complete

      expect(find.text('Quote 1'), findsOneWidget);
      expect(find.text('- Author 1'), findsOneWidget);
      expect(find.text('Quote 2'), findsOneWidget);
      expect(find.text('- Author 2'), findsOneWidget);
    });

    testWidgets('renders QuoteFeedLoaded with no quotes', (tester) async {
      whenListen(
        mockQuoteFeedBloc,
        Stream.fromIterable([
          const QuoteFeedLoaded(quotes: []),
        ]),
        initialState: QuoteFeedInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteFeedBloc>(
            create: (context) => mockQuoteFeedBloc,
            child: const QuoteFeedPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No quotes found.'), findsOneWidget);
    });

    testWidgets('renders QuoteFeedError', (tester) async {
      whenListen(
        mockQuoteFeedBloc,
        Stream.fromIterable([
          const QuoteFeedError(message: 'Error message'),
        ]),
        initialState: QuoteFeedInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteFeedBloc>(
            create: (context) => mockQuoteFeedBloc,
            child: const QuoteFeedPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error message'), findsOneWidget);
    });
  });
}
