part of 'quote_feed_bloc.dart';

abstract class QuoteFeedState extends Equatable {
  const QuoteFeedState();

  @override
  List<Object> get props => [];
}

class QuoteFeedInitial extends QuoteFeedState {}

class QuoteFeedLoading extends QuoteFeedState {}

class QuoteFeedLoaded extends QuoteFeedState {
  final List<Quote> quotes;

  const QuoteFeedLoaded({required this.quotes});

  @override
  List<Object> get props => [quotes];
}

class QuoteFeedError extends QuoteFeedState {
  final String message;

  const QuoteFeedError({required this.message});

  @override
  List<Object> get props => [message];
}
