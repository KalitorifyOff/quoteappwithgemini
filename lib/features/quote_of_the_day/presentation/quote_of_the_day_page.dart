import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/features/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';

class QuoteOfTheDayPage extends StatelessWidget {
  const QuoteOfTheDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
      ),
      body: BlocBuilder<QuoteOfTheDayBloc, QuoteOfTheDayState>(
        builder: (context, state) {
          if (state is QuoteOfTheDayLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuoteOfTheDayLoaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.quote.content,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '- ${state.quote.author}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is QuoteOfTheDayError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press the button to load quote'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<QuoteOfTheDayBloc>().add(GetQuoteOfTheDay());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
