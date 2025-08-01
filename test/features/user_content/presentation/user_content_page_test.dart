import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';
import 'package:streakdemo/features/user_content/presentation/user_quote_form_page.dart';
import 'package:streakdemo/features/user_content/presentation/user_quotes_page.dart';

class MockUserContentBloc extends MockBloc<UserContentEvent, UserContentState>
    implements UserContentBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Quote(content: 'any', author: 'any'));
    registerFallbackValue(const Category(name: 'any'));
    registerFallbackValue(UserContentInitial());
    registerFallbackValue(LoadUserContent());
    registerFallbackValue(AddUserQuote(const Quote(content: 'any', author: 'any')));
    registerFallbackValue(UpdateUserQuote(const Quote(content: 'any', author: 'any')));
    registerFallbackValue(DeleteUserQuote(1));
  });

  group('UserQuoteFormPage', () {
    late MockUserContentBloc mockUserContentBloc;

    setUp(() {
      mockUserContentBloc = MockUserContentBloc();
    });

    testWidgets('renders correctly for new quote', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuoteFormPage(),
          ),
        ),
      );

      expect(find.text('Create New Quote'), findsOneWidget);
      expect(find.text('Quote Content'), findsOneWidget);
      expect(find.text('Author'), findsOneWidget);
      expect(find.text('Add Quote'), findsOneWidget);
    });

    testWidgets('renders correctly for editing existing quote', (tester) async {
      const existingQuote = Quote(id: 1, content: 'Test Content', author: 'Test Author');
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuoteFormPage(quote: existingQuote),
          ),
        ),
      );

      expect(find.text('Edit Quote'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Test Content'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Test Author'), findsOneWidget);
      expect(find.text('Update Quote'), findsOneWidget);
    });

    testWidgets('validates empty fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuoteFormPage(),
          ),
        ),
      );

      await tester.tap(find.text('Add Quote'));
      await tester.pump();

      expect(find.text('Please enter some content'), findsOneWidget);
      expect(find.text('Please enter an author'), findsOneWidget);
    });

    testWidgets('dispatches AddUserQuote when adding new quote', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(UserContentInitial());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuoteFormPage(),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('quoteContentField')), 'New Quote Content');
      await tester.enterText(find.byKey(const Key('quoteAuthorField')), 'New Author');
      await tester.tap(find.text('Add Quote'));
      await tester.pumpAndSettle();

      verify(() => mockUserContentBloc.add(const AddUserQuote(Quote(content: 'New Quote Content', author: 'New Author', isFavorite: false)))).called(1);
    });

    testWidgets('dispatches UpdateUserQuote when updating existing quote', (tester) async {
      const existingQuote = Quote(id: 1, content: 'Old Content', author: 'Old Author');
      when(() => mockUserContentBloc.state).thenReturn(UserContentInitial());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuoteFormPage(quote: existingQuote),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('quoteContentField')), 'Updated Content');
      await tester.enterText(find.byKey(const Key('quoteAuthorField')), 'Updated Author');
      await tester.tap(find.text('Update Quote'));
      await tester.pumpAndSettle();

      verify(() => mockUserContentBloc.add(const UpdateUserQuote(Quote(id: 1, content: 'Updated Content', author: 'Updated Author', isFavorite: false)))).called(1);
    });
  });

  group('UserQuotesPage', () {
    late MockUserContentBloc mockUserContentBloc;

    setUp(() {
      mockUserContentBloc = MockUserContentBloc();
    });

    testWidgets('renders CircularProgressIndicator when UserContentLoading', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(UserContentLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders "No user-created quotes yet." when UserContentLoaded with empty quotes', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userQuotes: []));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      expect(find.text('No user-created quotes yet.'), findsOneWidget);
    });

    testWidgets('renders list of quotes when UserContentLoaded with quotes', (tester) async {
      const quotes = [
        Quote(id: 1, content: 'Quote 1', author: 'Author 1'),
        Quote(id: 2, content: 'Quote 2', author: 'Author 2'),
      ];
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userQuotes: quotes));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      expect(find.text('Quote 1'), findsOneWidget);
      expect(find.text('Author 1'), findsOneWidget);
      expect(find.text('Quote 2'), findsOneWidget);
      expect(find.text('Author 2'), findsOneWidget);
    });

    testWidgets('renders error message when UserContentError', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(const UserContentError(message: 'Test Error'));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      expect(find.text('Error: Test Error'), findsOneWidget);
    });

    testWidgets('navigates to UserQuoteFormPage when FAB is pressed', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userQuotes: []));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(UserQuoteFormPage), findsOneWidget);
      expect(find.text('Create New Quote'), findsOneWidget);
    });

    testWidgets('navigates to UserQuoteFormPage with existing quote when edit button is pressed', (tester) async {
      const quotes = [
        Quote(id: 1, content: 'Quote to Edit', author: 'Author to Edit'),
      ];
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userQuotes: quotes));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(UserQuoteFormPage), findsOneWidget);
      expect(find.text('Edit Quote'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Quote to Edit'), findsOneWidget);
    });

    testWidgets('dispatches DeleteUserQuote when delete button is pressed', (tester) async {
      const quotes = [
        Quote(id: 1, content: 'Quote to Delete', author: 'Author to Delete'),
      ];
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userQuotes: quotes));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserQuotesPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      verify(() => mockUserContentBloc.add(const DeleteUserQuote(1))).called(1);
    });
  });
}
