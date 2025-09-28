import 'package:hipster/features/auth/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class LoginState {
  final bool isLoading;
  final String? token;
  final String? error;

  const LoginState({this.isLoading = false, this.token, this.error});

  LoginState copyWith({bool? isLoading, String? token, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _repository;

  LoginViewModel(this._repository) : super(const LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, token: null);
    try {
      final token = await _repository.login(email, password);
      state = state.copyWith(isLoading: false, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
      final repo = ref.watch(authRepositoryProvider);
      return LoginViewModel(repo);
    });
