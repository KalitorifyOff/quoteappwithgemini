import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';

class UserQuoteFormPage extends StatefulWidget {
  final Quote? quote; // Null for new quote, not null for editing

  const UserQuoteFormPage({super.key, this.quote});

  @override
  State<UserQuoteFormPage> createState() => _UserQuoteFormPageState();
}

class _UserQuoteFormPageState extends State<UserQuoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.quote?.content ?? '');
    _authorController = TextEditingController(text: widget.quote?.author ?? '');
  }

  @override
  void dispose() {
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _saveQuote() {
    if (_formKey.currentState!.validate()) {
      final newQuote = Quote(
        id: widget.quote?.id,
        content: _contentController.text,
        author: _authorController.text,
        isFavorite: widget.quote?.isFavorite ?? false,
        categoryId: widget.quote?.categoryId,
      );

      if (widget.quote == null) {
        // Adding new quote
        context.read<UserContentBloc>().add(AddUserQuote(newQuote));
      } else {
        // Updating existing quote
        context.read<UserContentBloc>().add(UpdateUserQuote(newQuote));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quote == null ? 'Create New Quote' : 'Edit Quote'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('quoteContentField'),
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Quote Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('quoteAuthorField'),
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveQuote,
                child: Text(widget.quote == null ? 'Add Quote' : 'Update Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
