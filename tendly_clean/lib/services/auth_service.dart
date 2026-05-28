import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/keys.dart';

class AuthService {
  static final _sb = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://cvhqfmlvusefrydbstyd.supabase.co',
      anonKey: AppKeys.supabaseAnonKey,
    );
  }

  static Future<AuthResponse> signInWithEmail(String email, String password) =>
      _sb.auth.signInWithPassword(email: email, password: password);

  static Future<AuthResponse> signUpWithEmail(String email, String password) =>
      _sb.auth.signUp(email: email, password: password);

  static Future<void> signOut() => _sb.auth.signOut();
  static User? get currentUser => _sb.auth.currentUser;
  static bool get isLoggedIn   => currentUser != null;
}
