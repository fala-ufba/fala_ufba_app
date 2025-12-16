import 'dart:typed_data';

import 'package:fala_ufba/core/supabase_config.dart';
import 'package:fala_ufba/modules/home/models/home_filters.dart';
import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  }) async {
    final response = await supabase
        .from('reports')
        .select('*, building:buildings(*)')
        .order('created_at', ascending: false)
        .range((page - 1) * pageSize, page * pageSize);

    final hasNextPage = response.length > pageSize;
    final reports = response
        .take(pageSize)
        .map((e) => Report.fromJson(e))
        .toList();

    return (reports: reports, hasNextPage: hasNextPage);
  }

  Future<List<Report>> getReports(HomeFilters filters) async {
    // Emulate a delay of the request to the database. Remove this when the request is implemented.
    await Future.delayed(const Duration(seconds: 2));

    var reports = _mockReports;

    // TODO: Do the filter in the query to the database
    if (filters.status != null) {
      reports = reports
          .where((report) => report.status == filters.status)
          .toList();
    }

    // TODO: Do the filter in the query to the database
    if (filters.location != null && filters.location!.isNotEmpty) {
      reports = reports
          .where(
            (report) =>
                report.building?.name.toLowerCase().contains(
                  filters.location!.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }

    // TODO: Do the filter in the query to the database
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      reports = reports
          .where(
            (report) =>
                report.title.toLowerCase().contains(query) ||
                (report.description?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    return reports;
  }

  Future<void> upvoteReport({required int reportId, }) async {
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

  static final List<Report> _mockReports = [
    Report(
      id: 1,
      publicId: '102035',
      reporterId: 'user-1',
      title: 'Ar Condicionado Midea pingando',
      description:
          'Ar condicionado Midea pingando bastante quando a temperatura está abaixo de 20°C, só para quando é desligado.',
      status: ReportStatus.open,
      building: Building(
        id: 1,
        name: 'PAF2',
        campus: Campus.ondinaFederacao,
        createdAt: DateTime(2025, 11, 26, 14, 32),
      ),
      buildingSpecifier: 'Sala 301',
      attachments: ['https://img.olx.com.br/images/52/525571229749184.jpg'],
      createdAt: DateTime(2025, 11, 26, 14, 32),
      updatedAt: DateTime(2025, 11, 26, 14, 32),
    ),
    Report(
      id: 2,
      publicId: '102034',
      reporterId: 'user-2',
      title: 'Elevador do PAF1 com defeito',
      description:
          'O elevador do PAF1 está parando entre os andares e fazendo barulhos estranhos. Já ficou travado 2 vezes essa semana.',
      status: ReportStatus.inProgress,
      building: Building(
        id: 1,
        name: 'PAF1',
        campus: Campus.ondinaFederacao,
        createdAt: DateTime(2025, 11, 26, 14, 32),
      ),
      buildingSpecifier: 'Térreo',
      attachments: [],
      createdAt: DateTime(2025, 11, 25, 9, 15),
      updatedAt: DateTime(2025, 11, 25, 9, 15),
    ),
    Report(
      id: 3,
      publicId: '102028',
      reporterId: 'user-3',
      title: 'Vazamento no banheiro feminino',
      description:
          'Vazamento na pia do banheiro feminino do 2º andar. Água acumulando no chão e causando risco de escorregão.',
      status: ReportStatus.solved,
      building: Building(
        id: 1,
        name: 'Biblioteca',
        campus: Campus.ondinaFederacao,
        createdAt: DateTime(2025, 11, 26, 14, 32),
      ),
      buildingSpecifier: '2º Andar',
      attachments: ['https://img.olx.com.br/images/69/697506821099630.jpg'],
      createdAt: DateTime(2025, 11, 22, 16, 40),
      updatedAt: DateTime(2025, 11, 22, 16, 40),
    ),
    Report(
      id: 4,
      publicId: '102041',
      reporterId: 'user-4',
      title: 'Lâmpadas queimadas no corredor',
      description:
          'Três lâmpadas queimadas no corredor principal do térreo. À noite fica muito escuro e perigoso para transitar.',
      status: ReportStatus.open,
      building: Building(
        id: 1,
        name: 'PAF3',
        campus: Campus.ondinaFederacao,
        createdAt: DateTime(2025, 11, 26, 14, 32),
      ),
      buildingSpecifier: 'Corredor Térreo',
      attachments: [],
      createdAt: DateTime(2025, 11, 26, 8, 20),
      updatedAt: DateTime(2025, 11, 26, 8, 20),
    ),
    Report(
      id: 5,
      publicId: '102039',
      reporterId: 'user-5',
      title: 'Projetor da sala 205 não funciona',
      description:
          'Projetor não liga há 3 dias. Professores estão tendo que mudar de sala para dar aula, atrapalhando a grade.',
      status: ReportStatus.inProgress,
      building: Building(
        id: 1,
        name: 'PAF2',
        campus: Campus.ondinaFederacao,
        createdAt: DateTime(2025, 11, 26, 14, 32),
      ),
      buildingSpecifier: 'Sala 205',
      attachments: ['https://img.olx.com.br/images/79/799587078940577.jpg'],
      createdAt: DateTime(2025, 11, 24, 11, 55),
      updatedAt: DateTime(2025, 11, 24, 11, 55),
    ),
  ];
}
