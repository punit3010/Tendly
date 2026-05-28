// Keys are injected by Codemagic at build time via environment variables.
// Never hardcode keys here — this file is a placeholder only.
class AppKeys {
  static const claudeApiKey     = String.fromEnvironment('Claude_API_KEY');
  static const supabaseAnonKey  = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const revenueCatGoogle = String.fromEnvironment('REVENUECAT_GOOGLE_KEY');
}
