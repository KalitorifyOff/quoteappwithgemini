import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/core/database/database_helper.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';
import 'package:streakdemo/core/theme/app_theme.dart';
import 'package:streakdemo/features/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:streakdemo/features/quote_of_the_day/presentation/quote_of_the_day_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final QuoteRepository quoteRepository = QuoteRepository(databaseHelper);

    return MaterialApp(
      title: 'Positive Quote App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically switch between light and dark theme
      home: BlocProvider(
        create: (context) => QuoteOfTheDayBloc(quoteRepository: quoteRepository),
        child: const QuoteOfTheDayPage(),
      ),
    );
  }
}
