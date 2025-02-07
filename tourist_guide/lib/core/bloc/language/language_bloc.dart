import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences prefs;

  LanguageBloc({required this.prefs}) : super(LanguageInitial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) {
    final languageCode = prefs.getString('languageCode') ?? 'en';
    final countryCode = prefs.getString('countryCode') ?? 'US';
    emit(LanguageLoaded(
      languageCode: languageCode,
      countryCode: countryCode,
    ));
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    await prefs.setString('languageCode', event.languageCode);
    await prefs.setString('countryCode', event.countryCode);
    emit(LanguageLoaded(
      languageCode: event.languageCode,
      countryCode: event.countryCode,
    ));
  }
}