part of 'quote_feed_bloc.dart';

abstract class QuoteFeedEvent extends Equatable {
  const QuoteFeedEvent();

  @override
  List<Object> get props => [];
}

class LoadQuotes extends QuoteFeedEvent {}

class SearchQuotes extends QuoteFeedEvent {
  final String query;

  const SearchQuotes(this.query);

  @override
  List<Object> get props => [query];
}


