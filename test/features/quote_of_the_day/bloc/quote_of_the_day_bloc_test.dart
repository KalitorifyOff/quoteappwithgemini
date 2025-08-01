import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';
import 'package:streakdemo/features/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  group('QuoteOfTheDayBloc', () {
    late MockQuoteRepository mockQuoteRepository;
    late QuoteOfTheDayBloc quoteOfTheDayBloc;

    setUp(() {
      mockQuoteRepository = MockQuoteRepository();
      quoteOfTheDayBloc = QuoteOfTheDayBloc(quoteRepository: mockQuoteRepository);
    });

    tearDown(() {
      quoteOfTheDayBloc.close();
    });

    test('initial state is QuoteOfTheDayInitial', () {
      expect(quoteOfTheDayBloc.state, QuoteOfTheDayInitial());
    });

    blocTest<
        QuoteOfTheDayBloc,
        QuoteOfTheDayState>(
      'emits [QuoteOfTheDayLoading, QuoteOfTheDayLoaded] when GetQuoteOfTheDay is added and quotes are available',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenAnswer(
          (_) async => [const Quote(content: 'Test Quote', author: 'Test Author')],
        );
        return quoteOfTheDayBloc;
      },
      act: (bloc) => bloc.add(GetQuoteOfTheDay()),
      expect: () => [
        QuoteOfTheDayLoading(),
        const QuoteOfTheDayLoaded(quote: Quote(content: 'Test Quote', author: 'Test Author')),
      ],
    );

    blocTest<
        QuoteOfTheDayBloc,
        QuoteOfTheDayState>(
      'emits [QuoteOfTheDayLoading, QuoteOfTheDayError] when GetQuoteOfTheDay is added and no quotes are available',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenAnswer(
          (_) async => [],
        );
        return quoteOfTheDayBloc;
      },
      act: (bloc) => bloc.add(GetQuoteOfTheDay()),
      expect: () => [
        QuoteOfTheDayLoading(),
        const QuoteOfTheDayError(message: 'No quotes available.'),
      ],
    );

    blocTest<
        QuoteOfTheDayBloc,
        QuoteOfTheDayState>(
      'emits [QuoteOfTheDayLoading, QuoteOfTheDayError] when GetQuoteOfTheDay is added and an error occurs',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenThrow('Something went wrong');
        return quoteOfTheDayBloc;
      },
      act: (bloc) => bloc.add(GetQuoteOfTheDay()),
      expect: () => [
        QuoteOfTheDayLoading(),
        const QuoteOfTheDayError(message: 'Something went wrong'),
      ],
    );
  });
}
