import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _sb = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://cvhqfmlvusefrydbstyd.supabase.co',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  }

  static Future<AuthResponse> signInWithEmail(String email, String password) =>
      _sb.auth.signInWithPassword(email: email, password: password);

  static Future<AuthResponse> signUpWithEmail(String email, String password) =>
      _sb.auth.signUp(email: email, password: password);

  static Future<void> signOut() => _sb.auth.signOut();
  static User? get currentUser => _sb.auth.currentUser;
  static bool get isLoggedIn => currentUser != null;
  static Stream<AuthState> get authStateChanges => _sb.auth.onAuthStateChange;
}
