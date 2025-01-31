import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/bloc/favorites/favorites_bloc.dart';
import 'core/bloc/auth/auth_bloc.dart';
import 'core/bloc/places/places_bloc.dart';
import 'core/bloc/profile/profile_bloc.dart';
import 'core/bloc/theme/theme_bloc.dart';
import 'core/routes/app_router.dart';
import 'core/services/firebase_auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/firebase_data_uploader.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment this line to upload initial data (run only once)
   await FirebaseDataUploader.uploadInitialData();

  // Initialize services
  final authService = FirebaseAuthService();
  final firestoreService = FirestoreService();

  // Upload initial data only if needed
  final prefs = await SharedPreferences.getInstance();
  final hasUploadedData = prefs.getBool('has_uploaded_initial_data') ?? false;

  if (!hasUploadedData) {
    try {
      await FirebaseDataUploader.uploadInitialData();
      await prefs.setBool('has_uploaded_initial_data', true);
    } catch (e) {
      debugPrint('Error uploading initial data: $e');
    }
  }


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
              ),
            ),
            BlocProvider(
              create: (context) => FavoritesBloc(
                authService: context.read<FirebaseAuthService>(),
                firestoreService: context.read<FirestoreService>(),
              ),
            ),
            BlocProvider(
              create: (context) => ThemeBloc()..add(LoadTheme()),
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

        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'Egypt Tourist Guide'.tr(), // Add translation
          theme: currentTheme,
          themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.login,
        );
      },
    );
  }
}

// Add a simple BLoC observer for debugging
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType} $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }
}