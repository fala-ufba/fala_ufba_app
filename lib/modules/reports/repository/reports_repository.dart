import 'dart:typed_data';

import 'package:fala_ufba/core/supabase_config.dart';
import 'package:fala_ufba/modules/reports/models/comment.dart';
import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'reports_repository.g.dart';

@Riverpod(keepAlive: true)
ReportsRepository reportsRepository(Ref ref) {
  return ReportsRepository();
}

class ReportsRepository {
  Future<String> uploadImage(Uint8List imageBytes, String fileName) async {
    final extension = fileName.split('.').last.toLowerCase();
    if (!['png', 'jpg', 'jpeg'].contains(extension)) {
      throw Exception('Formato inválido. Apenas PNG e JPEG são permitidos.');
    }

    const maxSize = 5 * 1024 * 1024;
    if (imageBytes.length > maxSize) {
      throw Exception('Imagem muito grande. Máximo permitido: 5MB.');
    }

    final path = 'reports/$fileName';
    await supabase.storage
        .from('test_report_images')
        .uploadBinary(path, imageBytes);
    return supabase.storage.from('test_report_images').getPublicUrl(path);
  }

  Future<Report> createReport({
    required String title,
    String? description,
    int? buildingId,
    String? buildingSpecifier,
    String? publicId,
    List<String> attachments = const [],
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('reports')
        .insert({
          'public_id': publicId,
          'reporter_id': userId,
          'title': title,
          'description': description,
          'building_id': buildingId,
          'building_specifier': buildingSpecifier,
          'attachments': attachments,
          'status': 'OPEN',
        })
        .select('*, building:buildings(*)')
        .single();
    return Report.fromJson(response);
  }

  Future<({List<Report> reports, bool hasNextPage})> getPaginatedReports({
    required int page,
    required int pageSize,
    ReportStatus? status,
    int? buildingId,
    String? searchQuery,
  }) async {
    final from = (page - 1) * pageSize;
    final to = page * pageSize;

    var query = supabase.from('reports').select('*, building:buildings(*)');

    if (status != null) {
      query = query.eq('status', status.value);
    }
    if (buildingId != null) {
      query = query.eq('building_id', buildingId);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or(
        'title.ilike.%$searchQuery%,description.ilike.%$searchQuery%',
      );
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(from, to);

    final hasNextPage = response.length > pageSize;
    final reports = response
        .take(pageSize)
        .map((e) => Report.fromJson(e))
        .toList();

    return (reports: reports, hasNextPage: hasNextPage);
  }

  Future<Report?> getReportByPublicId(String publicId) async {
    try {
      final response = await supabase
          .from('reports')
          .select('*, building:buildings(*)')
          .eq('public_id', publicId)
          .maybeSingle();

      if (response == null) return null;
      return Report.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> upvoteReport({required int reportId}) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    await supabase.from('report_votes').insert({
      'report_id': reportId,
      'user_id': user.id,
    });
  }

  Future<void> removeUpvote({required int reportId}) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    await supabase
        .from('report_votes')
        .delete()
        .eq('report_id', reportId)
        .eq('user_id', user.id);
  }

  Future<List<String>> getUserUpvotedReports() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('report_votes')
        .select('report_id, report:reports(public_id)')
        .eq('user_id', user.id);

    return (response as List)
        .where((e) => e['report'] != null && e['report']['public_id'] != null)
        .map<String>((e) => e['report']['public_id'] as String)
        .toList();
  }

  Future<({List<Comment> comments, bool hasNextPage})> getReportComments({
    required int reportId,
    required int page,
    required int pageSize,
  }) async {
    final response = await supabase
        .from('report_comments')
        .select('*, profile:profiles!user_id(full_name)')
        .eq('report_id', reportId)
        .order('created_at', ascending: false)
        .range((page - 1) * pageSize, page * pageSize);

    final hasNextPage = response.length > pageSize;
    final comments = response.take(pageSize).map((e) {
      final userName = e['profile']?['full_name'] as String? ?? 'Usuário';
      return Comment.fromJson({...e, 'user_name': userName});
    }).toList();

    return (comments: comments, hasNextPage: hasNextPage);
  }

  Future<Comment> addComment({
    required int reportId,
    required String content,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await supabase
        .from('report_comments')
        .insert({'report_id': reportId, 'user_id': user.id, 'content': content})
        .select('*, profile:profiles!user_id(full_name)')
        .single();

    final userName = response['profile']?['full_name'] as String? ?? 'Usuário';
    return Comment.fromJson({...response, 'user_name': userName});
  }

  Future<int> getReportVotesCount({required int reportId}) async {
    final response = await supabase
        .from('report_votes')
        .select('id')
        .eq('report_id', reportId)
        .count(CountOption.exact);

    final totalVotes = response.count;
    return totalVotes;
  }
}
