import 'package:crypto_learn/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../repositories/user_repository.dart';


class AuthService extends GetxService {
  final user = User().obs;
  late GetStorage _box;
  late UserRepository _usersRepo;

  AuthService() {
    _usersRepo = UserRepository();
    _box = GetStorage();
  }

  Future<AuthService> init() async {
    user.listen((User _user) {
      _box.write('current_user', _user.toJson());
    });
    getCurrentUser();
    return this;
  }

  Future getCurrentUser() async {
    if (user.value.auth) {
      await _usersRepo.getCurrentUser();
    } else if (_box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      await _usersRepo.getCurrentUser();
    }
  }

  Future removeCurrentUser() async {
    user.value = User();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  Future setCurrentUser(User? user) async {
    if (user != null) {
      this.user.trigger(user);
    } else {
      this.user.trigger(User());
    }
  }

  bool get isAuth => user.value.auth;

  String get apiToken => (user.value.auth) ? user.value.token ?? '' : '';
}
