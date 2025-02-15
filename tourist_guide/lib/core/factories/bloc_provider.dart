import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_event.dart';
import '../bloc/places/places_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import 'interfaces/i_bloc_factory.dart';

class AppBlocProvider {
  final IBlocFactory _factory;

  AppBlocProvider(this._factory);

  List<BlocProvider> createProviders() {
    return [
      BlocProvider<AuthBloc>(
        create: (_) => _factory.createAuthBloc(),
      ),
      BlocProvider<FavoritesBloc>(
        create: (_) => _factory.createFavoritesBloc()..add(LoadFavorites()),
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => _factory.createProfileBloc(),
      ),
      BlocProvider<PlacesBloc>(
        create: (_) => _factory.createPlacesBloc()..add(LoadAllPlaces()),
      ),
      BlocProvider<ThemeBloc>(
        create: (_) => _factory.createThemeBloc()..add(LoadTheme()),
      ),
      BlocProvider<LanguageBloc>(
        create: (_) => _factory.createLanguageBloc()..add(LoadLanguage()),
      ),
    ];
  }
}