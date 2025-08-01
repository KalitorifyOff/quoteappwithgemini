import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';

part 'quote_feed_event.dart';
part 'quote_feed_state.dart';

class QuoteFeedBloc extends Bloc<QuoteFeedEvent, QuoteFeedState> {
  final QuoteRepository quoteRepository;

  QuoteFeedBloc({required this.quoteRepository}) : super(QuoteFeedInitial()) {
    on<LoadQuotes>(_onLoadQuotes);
    on<SearchQuotes>(_onSearchQuotes);
    on<FilterQuotesByCategory>(_onFilterQuotesByCategory);
  }

  Future<void> _onLoadQuotes(
    LoadQuotes event,
    Emitter<QuoteFeedState> emit,
  ) async {
    emit(QuoteFeedLoading());
    try {
      final quotes = await quoteRepository.getQuotes();
      emit(QuoteFeedLoaded(quotes: quotes));
    } catch (e) {
      emit(QuoteFeedError(message: e.toString()));
    }
  }

  Future<void> _onSearchQuotes(
    SearchQuotes event,
    Emitter<QuoteFeedState> emit,
  ) async {
    emit(QuoteFeedLoading());
    try {
      final quotes = await quoteRepository.searchQuotes(event.query);
      emit(QuoteFeedLoaded(quotes: quotes));
    } catch (e) {
      emit(QuoteFeedError(message: e.toString()));
    }
  }

  Future<void> _onFilterQuotesByCategory(
    FilterQuotesByCategory event,
    Emitter<QuoteFeedState> emit,
  ) async {
    emit(QuoteFeedLoading());
    try {
      final quotes = await quoteRepository.getQuotesByCategory(event.categoryId);
      emit(QuoteFeedLoaded(quotes: quotes));
    } catch (e) {
      emit(QuoteFeedError(message: e.toString()));
    }
  }
}
