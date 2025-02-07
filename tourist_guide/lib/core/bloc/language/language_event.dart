abstract class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String languageCode;
  final String countryCode;

  ChangeLanguage({required this.languageCode, required this.countryCode});
}

class LoadLanguage extends LanguageEvent {}