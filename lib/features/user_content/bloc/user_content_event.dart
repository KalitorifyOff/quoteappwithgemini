part of 'user_content_bloc.dart';

abstract class UserContentEvent extends Equatable {
  const UserContentEvent();

  @override
  List<Object> get props => [];
}

class LoadUserContent extends UserContentEvent {}

class AddUserQuote extends UserContentEvent {
  final Quote quote;

  const AddUserQuote(this.quote);

  @override
  List<Object> get props => [quote];
}

class UpdateUserQuote extends UserContentEvent {
  final Quote quote;

  const UpdateUserQuote(this.quote);

  @override
  List<Object> get props => [quote];
}

class DeleteUserQuote extends UserContentEvent {
  final int quoteId;

  const DeleteUserQuote(this.quoteId);

  @override
  List<Object> get props => [quoteId];
}

class AddUserCategory extends UserContentEvent {
  final Category category;

  const AddUserCategory(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateUserCategory extends UserContentEvent {
  final Category category;

  const UpdateUserCategory(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteUserCategory extends UserContentEvent {
  final int categoryId;

  const DeleteUserCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
