class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  bool isAuthenticated = false;
  String? userName;

  void signIn(String email) {
    isAuthenticated = true;
    userName = email.split('@').first.replaceAll('.', ' ').trim();
  }

  void register(String name, String email) {
    isAuthenticated = true;
    userName = name.trim().isEmpty ? email.split('@').first : name.trim();
  }

  void signOut() {
    isAuthenticated = false;
    userName = null;
  }
}
