import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_guide/core/repositories/interfaces/auth_repository.dart';
import 'package:tourist_guide/core/utils/seed_data.dart';
import 'core/bloc/language/language_bloc.dart';
import 'core/bloc/language/language_state.dart';
import 'core/bloc/simple_bloc_observer.dart';
import 'core/bloc/theme/theme_bloc.dart';
import 'core/di/dependency_injection.dart';
import 'core/repositories/interfaces/favorites_repository.dart';
import 'core/repositories/interfaces/user_repository.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize required services
  await EasyLocalization.ensureInitialized();

  // Enable BlocObserver for debugging
  Bloc.observer = SimpleBlocObserver();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Finally, initialize dependency injection
  await DependencyInjection.instance.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'EG'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          // Core Services
          Provider.value(value: DependencyInjection.instance.localStorageService),
          Provider.value(value: DependencyInjection.instance.authService),
          Provider.value(value: DependencyInjection.instance.firestoreService),
          Provider.value(value: DependencyInjection.instance.prefs),
          Provider.value(value: DependencyInjection.instance.appState),

          // Repositories
          Provider<IAuthRepository>.value(
            value: DependencyInjection.instance.getAuthRepository,
          ),
          Provider<IUserRepository>.value(
            value: DependencyInjection.instance.getUserRepository,
          ),
          Provider<IFavoritesRepository>.value(
            value: DependencyInjection.instance.getFavoritesRepository,
          ),


          // Factories
          Provider.value(value: DependencyInjection.instance.getBlocFactory),
          Provider.value(value: DependencyInjection.instance.getViewModelFactory),

        ],
        child: MultiBlocProvider(
          providers: DependencyInjection.instance.getBlocProvider.createProviders(),
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
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            final currentTheme = AppTheme.getTheme(themeState.isDark);

            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Egypt Tourist Guide'.tr(),
              theme: currentTheme,
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: AppRouter.login,
              builder: (context, child) {
                return BlocListener<LanguageBloc, LanguageState>(
                  listener: (context, state) {
                    if (state is LanguageLoaded) {
                      context.setLocale(Locale(
                        state.languageCode,
                        state.countryCode,
                      ));
                    }
                  },
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
