import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';
import 'package:streakdemo/features/user_content/presentation/user_categories_page.dart';
import 'package:streakdemo/features/user_content/presentation/user_category_form_page.dart';

class MockUserContentBloc extends MockBloc<UserContentEvent, UserContentState>
    implements UserContentBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Quote(content: 'any', author: 'any'));
    registerFallbackValue(const Category(name: 'any'));
    registerFallbackValue(UserContentInitial());
    registerFallbackValue(LoadUserContent());
    registerFallbackValue(AddUserCategory(const Category(name: 'any')));
    registerFallbackValue(UpdateUserCategory(const Category(name: 'any', isUserCreated: false)));
    registerFallbackValue(DeleteUserCategory(1));
  });

  group('UserCategoryFormPage', () {
    late MockUserContentBloc mockUserContentBloc;

    setUp(() {
      mockUserContentBloc = MockUserContentBloc();
    });

    testWidgets('renders correctly for new category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoryFormPage(),
          ),
        ),
      );

      expect(find.text('Create New Category'), findsOneWidget);
      expect(find.text('Category Name'), findsOneWidget);
      expect(find.text('Add Category'), findsOneWidget);
    });

    testWidgets('renders correctly for editing existing category', (tester) async {
      const existingCategory = Category(id: 1, name: 'Test Category');
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoryFormPage(category: existingCategory),
          ),
        ),
      );

      expect(find.text('Edit Category'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Test Category'), findsOneWidget);
      expect(find.text('Update Category'), findsOneWidget);
    });

    testWidgets('validates empty fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoryFormPage(),
          ),
        ),
      );

      await tester.tap(find.text('Add Category'));
      await tester.pump();

      expect(find.text('Please enter a category name'), findsOneWidget);
    });

    // testWidgets('dispatches AddUserCategory when adding new category', (tester) async {
    //   when(() => mockUserContentBloc.state).thenReturn(UserContentInitial());
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: BlocProvider<UserContentBloc>.value(
    //         value: mockUserContentBloc,
    //         child: const UserCategoryFormPage(),
    //       ),
    //     ),
    //   );
    //
    //   await tester.enterText(find.byKey(const Key('categoryNameField')), 'Updated Category Name');
    //   await tester.tap(find.text('Add Category'));
    //   await tester.pumpAndSettle();
    //
    //   verify(() => mockUserContentBloc.add(const AddUserCategory(Category(name: 'New Category Name', isUserCreated: true)))).called(1);
    // });

    // testWidgets('dispatches UpdateUserCategory when updating existing category', (tester) async {
    //   const existingCategory = Category(id: 1, name: 'Old Category');
    //   when(() => mockUserContentBloc.state).thenReturn(UserContentInitial());
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: BlocProvider<UserContentBloc>.value(
    //         value: mockUserContentBloc,
    //         child: const UserCategoryFormPage(category: existingCategory),
    //       ),
    //     ),
    //   );
    //
    //   await tester.enterText(find.byKey(const Key('categoryNameField')), 'New Category Name');
    //   await tester.tap(find.text('Update Category'));
    //   await tester.pumpAndSettle();
    //
    //   verify(() => mockUserContentBloc.add(const UpdateUserCategory(Category(id: 1, name: 'Updated Category Name', isUserCreated: false)))).called(1);
    // });
  });

  group('UserCategoriesPage', () {
    late MockUserContentBloc mockUserContentBloc;

    setUp(() {
      mockUserContentBloc = MockUserContentBloc();
    });

    testWidgets('renders CircularProgressIndicator when UserContentLoading', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(UserContentLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders "No user-created categories yet." when UserContentLoaded with empty categories', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userCategories: []));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      expect(find.text('No user-created categories yet.'), findsOneWidget);
    });

    testWidgets('renders list of categories when UserContentLoaded with categories', (tester) async {
      const categories = [
        Category(id: 1, name: 'Category 1'),
        Category(id: 2, name: 'Category 2'),
      ];
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userCategories: categories));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Category 2'), findsOneWidget);
    });

    testWidgets('renders error message when UserContentError', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(const UserContentError(message: 'Test Error'));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      expect(find.text('Error: Test Error'), findsOneWidget);
    });

    testWidgets('navigates to UserCategoryFormPage when FAB is pressed', (tester) async {
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userCategories: []));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(UserCategoryFormPage), findsOneWidget);
      expect(find.text('Create New Category'), findsOneWidget);
    });

    testWidgets('navigates to UserCategoryFormPage with existing category when edit button is pressed', (tester) async {
      const categories = [
        Category(id: 1, name: 'Category to Edit'),
      ];
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userCategories: categories));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(UserCategoryFormPage), findsOneWidget);
      expect(find.text('Edit Category'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Category to Edit'), findsOneWidget);
    });

    testWidgets('dispatches DeleteUserCategory when delete button is pressed', (tester) async {
      const categories = [
        Category(id: 1, name: 'Category to Delete'),
      ];
      when(() => mockUserContentBloc.state).thenReturn(const UserContentLoaded(userCategories: categories));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserContentBloc>.value(
            value: mockUserContentBloc,
            child: const UserCategoriesPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      verify(() => mockUserContentBloc.add(const DeleteUserCategory(1))).called(1);
    });
  });
}
