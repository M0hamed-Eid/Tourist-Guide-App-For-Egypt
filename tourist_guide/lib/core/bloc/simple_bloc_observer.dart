
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Add a simple BLoC observer for debugging
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('📢 ${bloc.runtimeType} Event: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('❌ ${bloc.runtimeType} Error: $error');
    debugPrint('StackTrace: $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('🔄 ${bloc.runtimeType} Change: Current: ${change.currentState} Next: ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('''
🔄 ${bloc.runtimeType} Transition:
  Event: ${transition.event}
  Current: ${transition.currentState}
  Next: ${transition.nextState}
''');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('✨ ${bloc.runtimeType} Created');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('🔒 ${bloc.runtimeType} Closed');
  }
}