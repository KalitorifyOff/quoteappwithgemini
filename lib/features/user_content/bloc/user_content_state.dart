part of 'user_content_bloc.dart';

abstract class UserContentState extends Equatable {
  const UserContentState();

  @override
  List<Object> get props => [];
}

class UserContentInitial extends UserContentState {}

class UserContentLoading extends UserContentState {}

class UserContentLoaded extends UserContentState {
  final List<Quote> userQuotes;
  final List<Category> userCategories;

  const UserContentLoaded({
    this.userQuotes = const [],
    this.userCategories = const [],
  });

  @override
  List<Object> get props => [userQuotes, userCategories];
}

class UserContentError extends UserContentState {
  final String message;

  const UserContentError({required this.message});

  @override
  List<Object> get props => [message];
}
