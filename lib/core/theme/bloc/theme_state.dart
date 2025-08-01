part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}