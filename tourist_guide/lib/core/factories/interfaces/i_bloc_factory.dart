import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../bloc/places/places_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';

abstract class IBlocFactory {
  AuthBloc createAuthBloc();
  FavoritesBloc createFavoritesBloc();
  ProfileBloc createProfileBloc();
  PlacesBloc createPlacesBloc();
  ThemeBloc createThemeBloc();
  LanguageBloc createLanguageBloc();
}