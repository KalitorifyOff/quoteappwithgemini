import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/core/database/database_helper.dart';
import 'package:streakdemo/core/database/repositories/quote_repository.dart';
import 'package:streakdemo/core/theme/app_theme.dart';
import 'package:streakdemo/features/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:streakdemo/features/quote_of_the_day/presentation/quote_of_the_day_page.dart';
import 'package:streakdemo/features/quote_feed/bloc/quote_feed_bloc.dart';
import 'package:streakdemo/features/quote_feed/presentation/quote_feed_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final QuoteRepository quoteRepository = QuoteRepository(databaseHelper);

    return MultiBlocProvider(
      providers: [
        BlocProvider<QuoteOfTheDayBloc>(
          create: (context) => QuoteOfTheDayBloc(quoteRepository: quoteRepository),
        ),
        BlocProvider<QuoteFeedBloc>(
          create: (context) => QuoteFeedBloc(quoteRepository: quoteRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Positive Quote App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Automatically switch between light and dark theme
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    QuoteOfTheDayPage(),
    QuoteFeedPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Feed',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}