import 'package:dio/dio.dart';
import 'package:hipster/core/services/dio_client.dart';
import 'package:hipster/core/services/hive_init.dart';
import 'package:hipster/features/users/model/user_model.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../repository/user_repository.dart';

class UserListState {
  final bool loading;
  final List<User> users;
  final Object? error;
  const UserListState({this.loading = false, this.users = const [], this.error});

  UserListState copyWith({bool? loading, List<User>? users, Object? error}) =>
      UserListState(loading: loading ?? this.loading, users: users ?? this.users, error: error);
}

class UserListViewModel extends StateNotifier<UserListState> {
  UserListViewModel(this._repo) : super(const UserListState());
  final UserRepository _repo;

  Future<void> load({bool refresh = false}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repo.getUsers(forceRefresh: refresh);
      state = state.copyWith(loading: false, users: data);
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }
}


final dioProvider = Provider<Dio>((ref) => buildDio());

final usersBoxProvider = Provider<Box<Map>>((ref) => Hive.box<Map>(kUsersBox));

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(dioProvider), ref.read(usersBoxProvider));
});

final userListVmProvider =
    StateNotifierProvider<UserListViewModel, UserListState>((ref) {
  return UserListViewModel(ref.read(userRepositoryProvider));
});