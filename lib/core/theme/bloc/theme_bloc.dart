import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeBloc() : super(const ThemeLoaded(themeMode: ThemeMode.system)) {
    on<ToggleTheme>(_onToggleTheme);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString(_themeKey);
    if (theme == 'light') {
      emit(const ThemeLoaded(themeMode: ThemeMode.light));
    } else if (theme == 'dark') {
      emit(const ThemeLoaded(themeMode: ThemeMode.dark));
    } else {
      emit(const ThemeLoaded(themeMode: ThemeMode.system));
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (state is ThemeLoaded) {
      final currentTheme = (state as ThemeLoaded).themeMode;
      ThemeMode newTheme;
      if (currentTheme == ThemeMode.light) {
        newTheme = ThemeMode.dark;
      } else {
        newTheme = ThemeMode.light;
      }
      await prefs.setString(_themeKey, newTheme == ThemeMode.light ? 'light' : 'dark');
      emit(ThemeLoaded(themeMode: newTheme));
    }
  }
}
