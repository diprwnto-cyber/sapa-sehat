import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.url,
      publishableKey: SupabaseConstants.publishableKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

// Global shortcut accessor
final supabase = Supabase.instance.client;
