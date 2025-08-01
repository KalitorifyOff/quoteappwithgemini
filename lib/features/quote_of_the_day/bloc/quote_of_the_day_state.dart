part of 'quote_of_the_day_bloc.dart';

abstract class QuoteOfTheDayState extends Equatable {
  const QuoteOfTheDayState();

  @override
  List<Object?> get props => [];
}

class QuoteOfTheDayInitial extends QuoteOfTheDayState {}

class QuoteOfTheDayLoading extends QuoteOfTheDayState {}

class QuoteOfTheDayLoaded extends QuoteOfTheDayState {
  final Quote quote;

  const QuoteOfTheDayLoaded({required this.quote});

  @override
  List<Object?> get props => [quote];
}

class QuoteOfTheDayError extends QuoteOfTheDayState {
  final String message;

  const QuoteOfTheDayError({required this.message});

  @override
  List<Object?> get props => [message];
}
