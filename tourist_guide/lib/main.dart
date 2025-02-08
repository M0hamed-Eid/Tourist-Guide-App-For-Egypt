import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/bloc/favorites/favorites_bloc.dart';
import 'core/bloc/auth/auth_bloc.dart';
import 'core/bloc/language/language_bloc.dart';
import 'core/bloc/language/language_event.dart';
import 'core/bloc/language/language_state.dart';
import 'core/bloc/places/places_bloc.dart';
import 'core/bloc/profile/profile_bloc.dart';
import 'core/bloc/simple_bloc_observer.dart';
import 'core/bloc/theme/theme_bloc.dart';
import 'core/routes/app_router.dart';
import 'core/services/firebase_auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable BlocObserver for debugging
  Bloc.observer = SimpleBlocObserver();


  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  final localStorageService = LocalStorageService();
  final authService = FirebaseAuthService();
  final firestoreService = FirestoreService();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'EG'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authService),
          RepositoryProvider.value(value: firestoreService),
          RepositoryProvider.value(value: localStorageService),
          BlocProvider(create: (context) => ThemeBloc()), // Theme bloc for app theme management
          RepositoryProvider.value(value: prefs),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                authService: context.read<FirebaseAuthService>(),
                firestoreService: context.read<FirestoreService>(),
              ),
            ),
            BlocProvider(
              create: (context) => PlacesBloc(
                firestoreService: context.read<FirestoreService>(),
                authService: context.read<FirebaseAuthService>(),
              )..add(LoadAllPlaces()),
            ),
            BlocProvider(
              create: (context) => ProfileBloc(
                authService: context.read<FirebaseAuthService>(),
                firestoreService: context.read<FirestoreService>(),
                localStorageService: context.read<LocalStorageService>(),
              ),
            ),
            BlocProvider(
              create: (context) => FavoritesBloc(
                authService: context.read<FirebaseAuthService>(),
                firestoreService: context.read<FirestoreService>(),
              )..add(LoadFavorites()),
            ),
            BlocProvider(
              create: (context) => ThemeBloc()..add(LoadTheme()),
            ),
            BlocProvider(  // Add this
              create: (context) => LanguageBloc(prefs: prefs)..add(LoadLanguage()),
            ),
          ],
          child: const TouristGuideApp(),
        ),
      ),
    ),
  );
}

class TouristGuideApp extends StatelessWidget {
  const TouristGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final currentTheme = AppTheme.getTheme(themeState.isDark);

        return  BlocListener<LanguageBloc, LanguageState>(  // Add this
          listener: (context, languageState) {
            if (languageState is LanguageLoaded) {
              context.setLocale(Locale(
                languageState.languageCode,
                languageState.countryCode,
              ));
            }
          },
          child:  MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'Egypt Tourist Guide'.tr(),
            theme: currentTheme,
            themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.login,
          ),
        );
      },
    );
  }
}

