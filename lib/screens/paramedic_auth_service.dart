import 'package:supabase_flutter/supabase_flutter.dart';

class ParamedicAuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> verifyParamedicId(String paramedicId) async {
    try {
      final response = await _client
          .from('paramedics')
          .select()
          .eq('paramedic_id', paramedicId);

      if (response is List && response.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}