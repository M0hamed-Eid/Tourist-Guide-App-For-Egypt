import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/core/repositories/interfaces/governorate_repository.dart';
import 'package:tourist_guide/core/repositories/interfaces/places_repository.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../bloc/places/places_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../repositories/interfaces/auth_repository.dart';
import '../../repositories/interfaces/favorites_repository.dart';
import '../../repositories/interfaces/user_repository.dart';
import '../../services/firestore_service.dart';
import '../../services/local_storage_service.dart';
import '../interfaces/i_bloc_factory.dart';

class BlocFactoryImpl implements IBlocFactory {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  final IFavoritesRepository _favoritesRepository;
  final IPlacesRepository _placesRepository;
  final IGovernorateRepository _governorateRepository;
  final FirestoreService _firestoreService;
  final LocalStorageService _localStorageService;
  final SharedPreferences _prefs;

  BlocFactoryImpl({
    required IAuthRepository authRepository,
    required IUserRepository userRepository,
    required IFavoritesRepository favoritesRepository,
    required IPlacesRepository placesRepository,
    required IGovernorateRepository governorateRepository,
    required FirestoreService firestoreService,
    required LocalStorageService localStorageService,
    required SharedPreferences prefs,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _favoritesRepository = favoritesRepository,
        _placesRepository = placesRepository,
        _governorateRepository = governorateRepository,
        _firestoreService = firestoreService,
        _localStorageService = localStorageService,
        _prefs = prefs;

  @override
  AuthBloc createAuthBloc() {
    return AuthBloc(
      authRepository: _authRepository,
      userRepository: _userRepository,
    );
  }

  @override
  FavoritesBloc createFavoritesBloc() {
    return FavoritesBloc(
      favoritesRepository: _favoritesRepository,
      authRepository: _authRepository,
    );
  }

  @override
  ProfileBloc createProfileBloc() {
    return ProfileBloc(
      authRepository: _authRepository,
      userRepository: _userRepository,
      localStorageService: _localStorageService,
    );
  }

  @override
  PlacesBloc createPlacesBloc() {
    return PlacesBloc(
      authRepository: _authRepository,
      placesRepository: _placesRepository,
    );
  }

  @override
  ThemeBloc createThemeBloc() {
    return ThemeBloc();
  }

  @override
  LanguageBloc createLanguageBloc() {
    return LanguageBloc(prefs: _prefs);
  }
}
