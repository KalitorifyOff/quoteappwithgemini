import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/core/database/models/category.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';

class UserCategoryFormPage extends StatefulWidget {
  final Category? category; // Null for new category, not null for editing

  const UserCategoryFormPage({super.key, this.category});

  @override
  State<UserCategoryFormPage> createState() => _UserCategoryFormPageState();
}

class _UserCategoryFormPageState extends State<UserCategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final newCategory = Category(
        id: widget.category?.id,
        name: _nameController.text,
        isUserCreated: widget.category == null ? true : widget.category!.isUserCreated,
      );

      if (widget.category == null) {
        // Adding new category
        context.read<UserContentBloc>().add(AddUserCategory(newCategory));
      } else {
        // Updating existing category
        context.read<UserContentBloc>().add(UpdateUserCategory(newCategory));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Create New Category' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('categoryNameField'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveCategory,
                child: Text(widget.category == null ? 'Add Category' : 'Update Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
