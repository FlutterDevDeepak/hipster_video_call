
import 'package:dio/dio.dart';
import 'package:hipster/core/constants/api_end_point.dart';
import 'package:hipster/features/users/model/user_model.dart';
import 'package:hive_ce/hive.dart';

abstract class UserRepository {
  Future<List<User>> getUsers({bool forceRefresh});
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dio, this._usersBox);
  final Dio _dio;
  final Box<Map> _usersBox;

  @override
  Future<List<User>> getUsers({bool forceRefresh = false}) async {
    if (forceRefresh) {
      try {
        final users = await _fetchRemote();
        await _saveAll(users);
        return users;
      } catch (_) {
        final cached = _getAllCached();
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    }
    try {
      final users = await _fetchRemote();
      await _saveAll(users);
      return users;
    } catch (_) {
      final cached = _getAllCached();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<User>> _fetchRemote() async {
    final res = await _dio.get(ApiEndPoint.users);
    final list = UserModel.fromJson(res.data);
    return list.data ?? [];
  }

  Future<void> _saveAll(List<User> users) async {
    for (final u in users) {
      await _usersBox.put(u.id, u.toJson());
    }
  }

  List<User> _getAllCached() {
    return _usersBox.values
        .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
