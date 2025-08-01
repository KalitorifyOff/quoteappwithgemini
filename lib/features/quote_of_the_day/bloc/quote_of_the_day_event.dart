part of 'quote_of_the_day_bloc.dart';

abstract class QuoteOfTheDayEvent extends Equatable {
  const QuoteOfTheDayEvent();

  @override
  List<Object> get props => [];
}

class GetQuoteOfTheDay extends QuoteOfTheDayEvent {}
