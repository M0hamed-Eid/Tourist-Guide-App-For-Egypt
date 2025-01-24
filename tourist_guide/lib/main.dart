import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/bloc/favorites/favorites_bloc.dart';
import 'core/bloc/auth/auth_bloc.dart';
import 'core/bloc/places/places_bloc.dart';
import 'core/bloc/profile/profile_bloc.dart';
import 'core/bloc/theme/theme_bloc.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'EG'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(),
          ),
          BlocProvider(create: (_) => PlacesBloc()..add(LoadAllPlaces())),
          BlocProvider(
            create: (_) => ThemeBloc(),
          ),
          BlocProvider(
            create: (_) => ProfileBloc(),
          ),
          BlocProvider(
            create: (_) => FavoritesBloc(),
          ),
          BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
        ],
        child: const TouristGuideApp(),
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
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'Egypt Tourist Guide',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.login,
        );
      },
    );
  }
}
