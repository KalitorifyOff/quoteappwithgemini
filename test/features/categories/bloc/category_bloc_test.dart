import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/repositories/category_repository.dart';
import 'package:streakdemo/features/categories/bloc/category_bloc.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

// Define a fake class for CategoryEvent
class FakeCategoryEvent extends Fake implements CategoryEvent {}

// Define a fake class for Category
class FakeCategory extends Fake implements Category {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCategoryEvent());
    registerFallbackValue(FakeCategory());
  });

  group('CategoryBloc', () {
    late MockCategoryRepository mockCategoryRepository;
    late CategoryBloc categoryBloc;

    setUp(() {
      mockCategoryRepository = MockCategoryRepository();
      categoryBloc = CategoryBloc(categoryRepository: mockCategoryRepository);
    });

    tearDown(() {
      categoryBloc.close();
    });

    test('initial state is CategoryInitial', () {
      expect(categoryBloc.state, CategoryInitial());
    });

    blocTest<
        CategoryBloc,
        CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when LoadCategories is added and categories are available',
      build: () {
        when(() => mockCategoryRepository.getCategories()).thenAnswer(
          (_) async => [const Category(name: 'Test Category')],
        );
        return categoryBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        CategoryLoading(),
        const CategoryLoaded(categories: [Category(name: 'Test Category')]),
      ],
    );

    blocTest<
        CategoryBloc,
        CategoryState>(
      'emits [CategoryLoading, CategoryError] when LoadCategories is added and an error occurs',
      build: () {
        when(() => mockCategoryRepository.getCategories()).thenThrow('Something went wrong');
        return categoryBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        CategoryLoading(),
        const CategoryError(message: 'Something went wrong'),
      ],
    );

    blocTest<
        CategoryBloc,
        CategoryState>(
      'adds LoadCategories when AddCategory is added',
      build: () {
        when(() => mockCategoryRepository.insertCategory(any())).thenAnswer((_) async => 1);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const AddCategory(Category(name: 'New Category'))),
      verify: (_) {
        verify(() => mockCategoryRepository.insertCategory(const Category(name: 'New Category'))).called(1);
        verify(() => mockCategoryRepository.getCategories()).called(1);
      },
    );

    blocTest<
        CategoryBloc,
        CategoryState>(
      'adds LoadCategories when UpdateCategory is added',
      build: () {
        when(() => mockCategoryRepository.updateCategory(any())).thenAnswer((_) async => 1);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const UpdateCategory(Category(id: 1, name: 'Updated Category'))),
      verify: (_) {
        verify(() => mockCategoryRepository.updateCategory(const Category(id: 1, name: 'Updated Category'))).called(1);
        verify(() => mockCategoryRepository.getCategories()).called(1);
      },
    );

    blocTest<
        CategoryBloc,
        CategoryState>(
      'adds LoadCategories when DeleteCategory is added',
      build: () {
        when(() => mockCategoryRepository.deleteCategory(any())).thenAnswer((_) async => 1);
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const DeleteCategory(1)),
      verify: (_) {
        verify(() => mockCategoryRepository.deleteCategory(1)).called(1);
        verify(() => mockCategoryRepository.getCategories()).called(1);
      },
    );
  });
}