import 'package:fala_ufba/modules/home/ui/widgets/filter_chips.dart';
import 'package:fala_ufba/modules/home/ui/widgets/report_card.dart';
import 'package:fala_ufba/modules/home/ui/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'Todos';
  String _selectedLocation = 'Todos';

  final List<_ReportData> _mockReports = const [
    _ReportData(
      status: 'Aberto',
      statusColor: Color(0xFF81C784),
      id: '102035',
      title: 'Ar Condicionado Midea pingando',
      description:
          'Ar condicionado Midea pingando bastante quando a temperatura está abaixo de 20°C, só para quando é desligado.',
      location: 'PAF2 - Sala 301',
      updatedAt: '26/11/2025 às 14h32',
      imagePath: 'https://img.olx.com.br/images/52/525571229749184.jpg',
    ),
    _ReportData(
      status: 'Em andamento',
      statusColor: Color(0xFFFFB74D),
      id: '102034',
      title: 'Elevador do PAF1 com defeito',
      description:
          'O elevador do PAF1 está parando entre os andares e fazendo barulhos estranhos. Já ficou travado 2 vezes essa semana.',
      location: 'PAF1 - Térreo',
      updatedAt: '25/11/2025 às 09h15',
    ),
    _ReportData(
      status: 'Resolvido',
      statusColor: Color(0xFF64B5F6),
      id: '102028',
      title: 'Vazamento no banheiro feminino',
      description:
          'Vazamento na pia do banheiro feminino do 2º andar. Água acumulando no chão e causando risco de escorregão.',
      location: 'Biblioteca - 2º Andar',
      updatedAt: '22/11/2025 às 16h40',
      imagePath: 'https://img.olx.com.br/images/69/697506821099630.jpg',
    ),
    _ReportData(
      status: 'Aberto',
      statusColor: Color(0xFF81C784),
      id: '102041',
      title: 'Lâmpadas queimadas no corredor',
      description:
          'Três lâmpadas queimadas no corredor principal do térreo. À noite fica muito escuro e perigoso para transitar.',
      location: 'PAF3 - Corredor Térreo',
      updatedAt: '26/11/2025 às 08h20',
    ),
    _ReportData(
      status: 'Em andamento',
      statusColor: Color(0xFFFFB74D),
      id: '102039',
      title: 'Projetor da sala 205 não funciona',
      description:
          'Projetor não liga há 3 dias. Professores estão tendo que mudar de sala para dar aula, atrapalhando a grade.',
      location: 'PAF2 - Sala 205',
      updatedAt: '24/11/2025 às 11h55',
      imagePath: 'https://img.olx.com.br/images/79/799587078940577.jpg',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final user = switch (authState) {
      AuthStateAuthenticated(:final user) => user,
      _ => null,
    };

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ReportSearchBar(controller: _searchController),
              const SizedBox(height: 12),
              FilterChips(
                selectedStatus: _selectedStatus,
                selectedLocation: _selectedLocation,
                onStatusChanged: (value) =>
                    setState(() => _selectedStatus = value),
                onLocationChanged: (value) =>
                    setState(() => _selectedLocation = value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  itemCount: _mockReports.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = _mockReports[index];
                    return ReportCard(
                      status: report.status,
                      statusColor: report.statusColor,
                      id: report.id,
                      title: report.title,
                      description: report.description,
                      location: report.location,
                      updatedAt: report.updatedAt,
                      imagePath: report.imagePath,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportData {
  final String status;
  final Color statusColor;
  final String id;
  final String title;
  final String description;
  final String location;
  final String updatedAt;
  final String? imagePath;

  const _ReportData({
    required this.status,
    required this.statusColor,
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.updatedAt,
    this.imagePath,
  });
}
