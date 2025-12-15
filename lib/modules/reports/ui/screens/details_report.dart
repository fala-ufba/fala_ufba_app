import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fala_ufba/modules/reports/models/report.dart'; // Seu import real

// 1. Busca o Report pelo ID (int)
final reportByIdProvider = FutureProvider.family<Report, int>((ref, id) async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('reports') // Nome da sua tabela
      .select('*, building:buildings(*)') // Faz join se building for tabela FK
      .eq('id', id)
      .single();
  
  return Report.fromJson(response);
});

// 2. Checa se o usuário já votou (usando tabela report_votes)
final userHasVotedProvider = FutureProvider.family<bool, int>((ref, reportId) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return false;

  final count = await Supabase.instance.client
      .from('report_votes')
      .count()
      .eq('report_id', reportId)
      .eq('user_id', user.id);

  return count > 0;
});