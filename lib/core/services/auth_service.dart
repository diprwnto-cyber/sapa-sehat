import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseClient _client = supabase;

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Registrasi akun baru & sinkronisasi data ke tabel 'pengguna'
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String namaLengkap,
    required String noHp,
    int? roleId,
  }) async {
    // 1. Register di Supabase Auth
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'nama_lengkap': namaLengkap.trim(),
        'no_hp': noHp.trim(),
      },
    );

    final user = response.user;
    if (user != null) {
      // 2. Sinkronisasi profil ke tabel 'public.pengguna'
      try {
        await _client.from('pengguna').upsert({
          'id': user.id,
          'nama_lengkap': namaLengkap.trim(),
          'email': email.trim(),
          'no_hp': noHp.trim(),
          'role_id': roleId ?? 1, // Default role misal: Pasien (1)
          'status': 'aktif',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        // Jika tabel memiliki RLS atau trigger otomatis di Supabase, jangan gagalkan registrasi
        // Catat error untuk debugging
      }
    }

    return response;
  }

  /// Login menggunakan Email & Password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Logout dari Supabase
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Lupa Password (kirim email reset password)
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email.trim());
  }

  /// Ambil data profil dari tabel 'pengguna'
  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final data = await _client
          .from('pengguna')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) return data;

      // Fallback jika id menggunakan email
      return await _client
          .from('pengguna')
          .select()
          .eq('email', user.email ?? '')
          .maybeSingle();
    } catch (_) {
      // Fallback ke user_metadata dari Supabase Auth
      return {
        'nama_lengkap': user.userMetadata?['nama_lengkap'] ?? user.email ?? 'Pengguna',
        'email': user.email ?? '',
        'no_hp': user.userMetadata?['no_hp'] ?? '-',
      };
    }
  }
}

final authService = AuthService();
