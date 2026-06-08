import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

class SupabaseService {
  // Placeholder values - user should replace these with actual values
  static const String _supabaseUrl = 'https://placeholder.supabase.co';
  static const String _supabaseAnonKey = 'placeholder_anon_key';

  SupabaseClient get client => Supabase.instance.client;

  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
      );
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      debugPrint('Using fallback mock/local mode where possible. Please update Supabase credentials.');
    }
  }
}
