import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/core/database/repositories/category_repository.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Quote(content: 'any', author: 'any'));
    registerFallbackValue(const Category(name: 'any'));
  });

  group('UserContentBloc', () {
    late MockQuoteRepository mockQuoteRepository;
    late MockCategoryRepository mockCategoryRepository;
    late UserContentBloc userContentBloc;

    setUp(() {
      mockQuoteRepository = MockQuoteRepository();
      mockCategoryRepository = MockCategoryRepository();
      userContentBloc = UserContentBloc(
        quoteRepository: mockQuoteRepository,
        categoryRepository: mockCategoryRepository,
      );
    });

    tearDown(() {
      userContentBloc.close();
    });

    test('initial state is UserContentInitial', () {
      expect(userContentBloc.state, UserContentInitial());
    });

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when LoadUserContent is added',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => []);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(LoadUserContent()),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [], userCategories: []),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentError] when LoadUserContent fails',
      build: () {
        when(() => mockQuoteRepository.getQuotes()).thenThrow('Error loading quotes');
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(LoadUserContent()),
      expect: () => [
        UserContentLoading(),
        const UserContentError(message: 'Error loading quotes'),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when AddUserQuote is added',
      build: () {
        when(() => mockQuoteRepository.insertQuote(any())).thenAnswer((_) async => 1);
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => [const Quote(id: 1, content: 'New Quote', author: 'Author')]);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const AddUserQuote(Quote(content: 'New Quote', author: 'Author'))),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [Quote(id: 1, content: 'New Quote', author: 'Author')], userCategories: []),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentError] when AddUserQuote fails',
      build: () {
        when(() => mockQuoteRepository.insertQuote(any())).thenThrow('Error adding quote');
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const AddUserQuote(Quote(content: 'New Quote', author: 'Author'))),
      expect: () => [
        const UserContentError(message: 'Error adding quote'),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when UpdateUserQuote is added',
      build: () {
        when(() => mockQuoteRepository.updateQuote(any())).thenAnswer((_) async => 1);
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => [const Quote(id: 1, content: 'Updated Quote', author: 'Author')]);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserQuote(Quote(id: 1, content: 'Updated Quote', author: 'Author'))),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [Quote(id: 1, content: 'Updated Quote', author: 'Author')], userCategories: []),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentError] when UpdateUserQuote fails',
      build: () {
        when(() => mockQuoteRepository.updateQuote(any())).thenThrow('Error updating quote');
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserQuote(Quote(id: 1, content: 'Updated Quote', author: 'Author'))),
      expect: () => [
        const UserContentError(message: 'Error updating quote'),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when DeleteUserQuote is added',
      build: () {
        when(() => mockQuoteRepository.deleteQuote(any())).thenAnswer((_) async => 1);
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => []);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const DeleteUserQuote(1)),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [], userCategories: []),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentError] when DeleteUserQuote fails',
      build: () {
        when(() => mockQuoteRepository.deleteQuote(any())).thenThrow('Error deleting quote');
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const DeleteUserQuote(1)),
      expect: () => [
        const UserContentError(message: 'Error deleting quote'),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when AddUserCategory is added',
      build: () {
        when(() => mockCategoryRepository.insertCategory(any())).thenAnswer((_) async => 1);
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => []);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [const Category(id: 1, name: 'New Category')]);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const AddUserCategory(Category(name: 'New Category'))),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [], userCategories: [Category(id: 1, name: 'New Category')]),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentError] when AddUserCategory fails',
      build: () {
        when(() => mockCategoryRepository.insertCategory(any())).thenThrow('Error adding category');
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const AddUserCategory(Category(name: 'New Category'))),
      expect: () => [
        const UserContentError(message: 'Error adding category'),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when UpdateUserCategory is added',
      build: () {
        when(() => mockCategoryRepository.updateCategory(any())).thenAnswer((_) async => 1);
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => []);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [const Category(id: 1, name: 'Updated Category')]);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserCategory(Category(id: 1, name: 'Updated Category'))),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [], userCategories: [Category(id: 1, name: 'Updated Category')]),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentError] when UpdateUserCategory fails',
      build: () {
        when(() => mockCategoryRepository.updateCategory(any())).thenThrow('Error updating category');
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserCategory(Category(id: 1, name: 'Updated Category'))),
      expect: () => [
        const UserContentError(message: 'Error updating category'),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentLoading, UserContentLoaded] when DeleteUserCategory is added',
      build: () {
        when(() => mockCategoryRepository.deleteCategory(any())).thenAnswer((_) async => 1);
        when(() => mockQuoteRepository.getQuotes()).thenAnswer((_) async => []);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const DeleteUserCategory(1)),
      expect: () => [
        UserContentLoading(),
        const UserContentLoaded(userQuotes: [], userCategories: []),
      ],
    );

    blocTest<
        UserContentBloc,
        UserContentState>(
      'emits [UserContentError] when DeleteUserCategory fails',
      build: () {
        when(() => mockCategoryRepository.deleteCategory(any())).thenThrow('Error deleting category');
        return userContentBloc;
      },
      act: (bloc) => bloc.add(const DeleteUserCategory(1)),
      expect: () => [
        const UserContentError(message: 'Error deleting category'),
      ],
    );
  });
}
