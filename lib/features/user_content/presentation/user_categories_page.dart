import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';
import 'package:streakdemo/features/user_content/presentation/user_category_form_page.dart';

class UserCategoriesPage extends StatelessWidget {
  const UserCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Categories'),
      ),
      body: BlocBuilder<UserContentBloc, UserContentState>(
        builder: (context, state) {
          if (state is UserContentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserContentLoaded) {
            if (state.userCategories.isEmpty) {
              return const Center(child: Text('No user-created categories yet.'));
            } else {
              return ListView.builder(
                itemCount: state.userCategories.length,
                itemBuilder: (context, index) {
                  final category = state.userCategories[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(category.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => UserCategoryFormPage(category: category),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<UserContentBloc>().add(DeleteUserCategory(category.id!));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is UserContentError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const UserCategoryFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
