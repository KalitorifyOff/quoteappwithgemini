import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/features/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';

class DailyQuoteWidget extends StatelessWidget {
  const DailyQuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteOfTheDayBloc, QuoteOfTheDayState>(
      builder: (context, state) {
        if (state is QuoteOfTheDayLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuoteOfTheDayLoaded) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.quote.content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  '- ${state.quote.author}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        } else if (state is QuoteOfTheDayError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No quote available'));
      },
    );
  }
}
