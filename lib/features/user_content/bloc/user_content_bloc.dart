import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/repositories/category_repository.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';

part 'user_content_event.dart';
part 'user_content_state.dart';

class UserContentBloc extends Bloc<UserContentEvent, UserContentState> {
  final QuoteRepository quoteRepository;
  final CategoryRepository categoryRepository;

  UserContentBloc({
    required this.quoteRepository,
    required this.categoryRepository,
  }) : super(UserContentInitial()) {
    on<LoadUserContent>(_onLoadUserContent);
    on<AddUserQuote>(_onAddUserQuote);
    on<UpdateUserQuote>(_onUpdateUserQuote);
    on<DeleteUserQuote>(_onDeleteUserQuote);
    on<AddUserCategory>(_onAddUserCategory);
    on<UpdateUserCategory>(_onUpdateUserCategory);
    on<DeleteUserCategory>(_onDeleteUserCategory);
  }

  Future<void> _onLoadUserContent(
    LoadUserContent event,
    Emitter<UserContentState> emit,
  ) async {
    emit(UserContentLoading());
    try {
      final userQuotes = await quoteRepository.getQuotes();
      final userCategories = await categoryRepository.getCategories();
      emit(UserContentLoaded(
        userQuotes: userQuotes,
        userCategories: userCategories,
      ));
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }

  Future<void> _onAddUserQuote(
    AddUserQuote event,
    Emitter<UserContentState> emit,
  ) async {
    try {
      await quoteRepository.insertQuote(event.quote);
      add(LoadUserContent()); // Reload content after adding
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserQuote(
    UpdateUserQuote event,
    Emitter<UserContentState> emit,
  ) async {
    try {
      await quoteRepository.updateQuote(event.quote);
      add(LoadUserContent()); // Reload content after updating
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUserQuote(
    DeleteUserQuote event,
    Emitter<UserContentState> emit,
  ) async {
    try {
      await quoteRepository.deleteQuote(event.quoteId);
      add(LoadUserContent()); // Reload content after deleting
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }

  Future<void> _onAddUserCategory(
    AddUserCategory event,
    Emitter<UserContentState> emit,
  ) async {
    try {
      await categoryRepository.insertCategory(event.category);
      add(LoadUserContent()); // Reload content after adding
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserCategory(
    UpdateUserCategory event,
    Emitter<UserContentState> emit,
  ) async {
    try {
      await categoryRepository.updateCategory(event.category);
      add(LoadUserContent()); // Reload content after updating
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUserCategory(
    DeleteUserCategory event,
    Emitter<UserContentState> emit,
  ) async {
    try {
      await categoryRepository.deleteCategory(event.categoryId);
      add(LoadUserContent()); // Reload content after deleting
    } catch (e) {
      emit(UserContentError(message: e.toString()));
    }
  }
}
