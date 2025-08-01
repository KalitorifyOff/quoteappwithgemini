import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/core/database/models/quote.dart';
import 'package:streakdemo/features/user_content/bloc/user_content_bloc.dart';
import 'package:streakdemo/features/user_content/presentation/user_quote_form_page.dart';

class UserQuotesPage extends StatelessWidget {
  const UserQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quotes'),
      ),
      body: BlocBuilder<UserContentBloc, UserContentState>(
        builder: (context, state) {
          if (state is UserContentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserContentLoaded) {
            if (state.userQuotes.isEmpty) {
              return const Center(child: Text('No user-created quotes yet.'));
            } else {
              return ListView.builder(
                itemCount: state.userQuotes.length,
                itemBuilder: (context, index) {
                  final quote = state.userQuotes[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(quote.content),
                      subtitle: Text(quote.author),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => UserQuoteFormPage(quote: quote),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<UserContentBloc>().add(DeleteUserQuote(quote.id!));
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
              builder: (_) => const UserQuoteFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
