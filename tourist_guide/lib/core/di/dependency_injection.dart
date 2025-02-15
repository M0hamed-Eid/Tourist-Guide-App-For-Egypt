import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../factories/bloc_provider.dart';
import '../factories/implementations/bloc_factory_impl.dart';
import '../factories/implementations/view_model_factory_impl.dart';
import '../factories/interfaces/i_bloc_factory.dart';
import '../factories/interfaces/i_view_model_factory.dart';
import '../repositories/implementations/governorate_repository_impl.dart';
import '../repositories/implementations/places_repository_impl.dart';
import '../repositories/interfaces/governorate_repository.dart';
import '../repositories/interfaces/auth_repository.dart';
import '../repositories/implementations/auth_repository_impl.dart';
import '../repositories/implementations/favorites_repository_impl.dart';
import '../repositories/implementations/user_repository_impl.dart';
import '../repositories/interfaces/favorites_repository.dart';
import '../repositories/interfaces/places_repository.dart';
import '../repositories/interfaces/user_repository.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import '../singleton/app_state_singleton.dart';

class DependencyInjection {
  static final instance = DependencyInjection._();

  DependencyInjection._();

  // Core Services
  late final AppStateSingleton appState;
  late final SharedPreferences prefs;
  late final FirebaseAuthService authService;
  late final FirestoreService firestoreService;
  late final LocalStorageService localStorageService;

  // Repositories
  late final IAuthRepository authRepository;
  late final IUserRepository userRepository;
  late final IFavoritesRepository favoritesRepository;
  late final IPlacesRepository placesRepository;
  late final IGovernorateRepository governorateRepository;

  // Factories
  late final IBlocFactory blocFactory;
  late final AppBlocProvider blocProvider;
  late final IViewModelFactory viewModelFactory;

  Future<void> initialize() async {
    try {
      // Initialize core services
      appState = AppStateSingleton();
      prefs = await SharedPreferences.getInstance();
      authService = FirebaseAuthService();
      firestoreService = FirestoreService();
      localStorageService = LocalStorageService();

      // Initialize repositories
      authRepository = AuthRepositoryImpl(authService);
      userRepository = UserRepositoryImpl(firestoreService);
      favoritesRepository = FavoritesRepositoryImpl(firestoreService);
      placesRepository = PlacesRepositoryImpl(firestoreService);
      governorateRepository = GovernorateRepositoryImpl(firestoreService);

      // Initialize factories
      blocFactory = BlocFactoryImpl(
        authRepository: authRepository,
        userRepository: userRepository,
        favoritesRepository: favoritesRepository,
        placesRepository: placesRepository,
        governorateRepository: governorateRepository,
        firestoreService: firestoreService,
        localStorageService: localStorageService,
        prefs: prefs,
      );

      blocProvider = AppBlocProvider(blocFactory);

      viewModelFactory = ViewModelFactoryImpl(
        blocFactory: blocFactory,
        appState: appState,
      );
    } catch (e) {
      debugPrint('Error initializing dependencies: $e');
      rethrow;
    }
  }

  // Service Getters
  FirebaseAuthService get getAuthService => authService;
  FirestoreService get getFirestoreService => firestoreService;
  LocalStorageService get getLocalStorageService => localStorageService;
  SharedPreferences get getPrefs => prefs;
  AppStateSingleton get getAppState => appState;

  // Repository Getters
  IAuthRepository get getAuthRepository => authRepository;
  IUserRepository get getUserRepository => userRepository;
  IFavoritesRepository get getFavoritesRepository => favoritesRepository;
  IPlacesRepository get getPlacesRepository => placesRepository;
  IGovernorateRepository get getGovernorateRepository => governorateRepository;

  // Factory Getters
  IBlocFactory get getBlocFactory => blocFactory;
  AppBlocProvider get getBlocProvider => blocProvider;
  IViewModelFactory get getViewModelFactory => viewModelFactory;
}