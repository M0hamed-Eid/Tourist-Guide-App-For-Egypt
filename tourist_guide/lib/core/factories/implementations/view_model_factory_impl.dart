import '../../../screens/auth/login/login_view_model.dart';
import '../../../screens/auth/signup/signup_view_model.dart';
import '../../singleton/app_state_singleton.dart';
import '../interfaces/i_bloc_factory.dart';
import '../interfaces/i_view_model_factory.dart';

class ViewModelFactoryImpl implements IViewModelFactory {
  final IBlocFactory _blocFactory;
  final AppStateSingleton _appState;

  ViewModelFactoryImpl({
    required IBlocFactory blocFactory,
    required AppStateSingleton appState,
  })  : _blocFactory = blocFactory,
        _appState = appState;

  @override
  LoginViewModel createLoginViewModel() {
    return LoginViewModel(
      authBloc: _blocFactory.createAuthBloc(),
      appState: _appState,
    );
  }

  @override
  SignUpViewModel createSignUpViewModel() {
    return SignUpViewModel(
      authBloc: _blocFactory.createAuthBloc(),
      appState: _appState,
    );
  }
}