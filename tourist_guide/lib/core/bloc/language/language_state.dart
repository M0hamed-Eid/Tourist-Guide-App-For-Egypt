abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final String languageCode;
  final String countryCode;

  LanguageLoaded({required this.languageCode, required this.countryCode});
}