import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';

import 'dart:math';

part 'quote_of_the_day_event.dart';
part 'quote_of_the_day_state.dart';

class QuoteOfTheDayBloc extends Bloc<QuoteOfTheDayEvent, QuoteOfTheDayState> {
  final QuoteRepository quoteRepository;

  QuoteOfTheDayBloc({required this.quoteRepository}) : super(QuoteOfTheDayInitial()) {
    on<GetQuoteOfTheDay>(_onGetQuoteOfTheDay);
  }

  Future<void> _onGetQuoteOfTheDay(
    GetQuoteOfTheDay event,
    Emitter<QuoteOfTheDayState> emit,
  ) async {
    emit(QuoteOfTheDayLoading());
    try {
      final quotes = await quoteRepository.getQuotes();
      if (quotes.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(quotes.length);
        emit(QuoteOfTheDayLoaded(quote: quotes[randomIndex]));
      } else {
        emit(const QuoteOfTheDayError(message: 'No quotes available.'));
      }
    } catch (e) {
      emit(QuoteOfTheDayError(message: e.toString()));
    }
  }
}
