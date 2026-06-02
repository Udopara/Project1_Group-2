import 'dummy_database.dart';

class Session {
  static UserModel? currentUser;

  static void login(String email, String password) {
    currentUser = DummyDatabase.login(email, password);
  }

  static void logout() {
    currentUser = null;
  }

  static bool get isLoggedIn => currentUser != null;
}
