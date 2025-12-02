import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Di dalam class AuthProvider

  Future<void> updateUserName(String newName) async {
    try {
      final supabase = Supabase.instance.client;

      // Mengirim update ke Supabase
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'name': newName}, // Update field 'name' di metadata
        ),
      );

      // Refresh state agar UI ProfileScreen otomatis berubah
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating name: $e");
      rethrow; // Lempar error agar bisa ditangkap di ProfileScreen (untuk SnackBar)
    }
  }

  AuthProvider() {
    _init();
  }

  void _init() {
    _user = _supabase.auth.currentUser;
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _user = response.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      _user = response.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Fix OAuth - The method name may differ in Supabase Flutter 2.10.x
      // Check: https://supabase.com/docs/reference/dart/auth-signinwithoauth
      // Try: await _supabase.auth.signInWithOAuth(OAuthProvider.google);
      // Or: await _supabase.auth.signInWithOAuth(provider: OAuthProvider.google);

      _errorMessage =
          'Google OAuth not yet implemented. Please use email sign-in.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Fix OAuth - The method name may differ in Supabase Flutter 2.10.x
      // Check: https://supabase.com/docs/reference/dart/auth-signinwithoauth
      // Try: await _supabase.auth.signInWithOAuth(OAuthProvider.facebook);
      // Or: await _supabase.auth.signInWithOAuth(provider: OAuthProvider.facebook);

      _errorMessage =
          'Facebook OAuth not yet implemented. Please use email sign-in.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
