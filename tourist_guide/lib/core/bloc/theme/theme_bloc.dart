import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_colors.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDark: false)) {
    on<ToggleTheme>(_handleToggleTheme);
    on<LoadTheme>(_handleLoadTheme);
  }

  Future<void> _handleToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = !(state.isDark);
    await prefs.setBool('isDark', isDark);
    AppColors.initialize(isDark);
    emit(ThemeState(isDark: isDark));
  }

  Future<void> _handleLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    AppColors.initialize(isDark);
    emit(ThemeState(isDark: isDark));
  }
}