import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/features/quote_feed/bloc/quote_feed_bloc.dart';

class QuoteFeedPage extends StatefulWidget {
  const QuoteFeedPage({super.key});

  @override
  State<QuoteFeedPage> createState() => _QuoteFeedPageState();
}

class _QuoteFeedPageState extends State<QuoteFeedPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuoteFeedBloc>().add(LoadQuotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Feed'),
      ),
      body: BlocBuilder<QuoteFeedBloc, QuoteFeedState>(
        builder: (context, state) {
          if (state is QuoteFeedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuoteFeedLoaded) {
            if (state.quotes.isEmpty) {
              return const Center(child: Text('No quotes found.'));
            }
            return ListView.builder(
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                final quote = state.quotes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.content,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '- ${quote.author}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is QuoteFeedError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
