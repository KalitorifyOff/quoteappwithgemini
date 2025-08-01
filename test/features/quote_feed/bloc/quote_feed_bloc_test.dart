import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';
import 'package:streakdemo/features/quote_feed/bloc/quote_feed_bloc.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  group('QuoteFeedBloc', () {
    late MockQuoteRepository mockQuoteRepository;
    late QuoteFeedBloc quoteFeedBloc;

    setUp(() {
      mockQuoteRepository = MockQuoteRepository();
      quoteFeedBloc = QuoteFeedBloc(quoteRepository: mockQuoteRepository);
    });

    tearDown(() {
      quoteFeedBloc.close();
    });

    test('initial state is QuoteFeedInitial', () {
      expect(quoteFeedBloc.state, QuoteFeedInitial());
    });

    blocTest<
        QuoteFeedBloc,
        QuoteFeedState>(
      'emits [QuoteFeedLoading, QuoteFeedLoaded] when LoadQuotes is added and quotes are available',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenAnswer(
          (_) async => [const Quote(content: 'Test Quote', author: 'Test Author')],
        );
        return quoteFeedBloc;
      },
      act: (bloc) => bloc.add(LoadQuotes()),
      expect: () => [
        QuoteFeedLoading(),
        const QuoteFeedLoaded(quotes: [Quote(content: 'Test Quote', author: 'Test Author')]),
      ],
    );

    blocTest<
        QuoteFeedBloc,
        QuoteFeedState>(
      'emits [QuoteFeedLoading, QuoteFeedError] when LoadQuotes is added and an error occurs',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenThrow('Something went wrong');
        return quoteFeedBloc;
      },
      act: (bloc) => bloc.add(LoadQuotes()),
      expect: () => [
        QuoteFeedLoading(),
        const QuoteFeedError(message: 'Something went wrong'),
      ],
    );

    blocTest<
        QuoteFeedBloc,
        QuoteFeedState>(
      'emits [QuoteFeedLoading, QuoteFeedLoaded] when SearchQuotes is added and quotes are available',
      build: () {
        when(() => mockQuoteRepository.searchQuotes(any())).thenAnswer(
          (_) async => [const Quote(content: 'Search Result', author: 'Search Author')],
        );
        return quoteFeedBloc;
      },
      act: (bloc) => bloc.add(const SearchQuotes('test')),
      expect: () => [
        QuoteFeedLoading(),
        const QuoteFeedLoaded(quotes: [Quote(content: 'Search Result', author: 'Search Author')]),
      ],
    );

    
  });
}
