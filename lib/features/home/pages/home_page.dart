import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/filters.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../services/export_service.dart';
import '../widgets/header.dart';
import '../widgets/filters_bar.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/charts_section.dart';
import '../widgets/alerts_panel.dart';
import '../widgets/footer.dart';

// Provider para o repositório
final mockRepositoryProvider = Provider<MockRepository>((ref) {
  return MockRepository();
});

// Provider para os dados do dashboard
final dashboardDataProvider =
    FutureProvider.family<DashboardData, AppFilters>((ref, filtros) async {
  final repository = ref.read(mockRepositoryProvider);
  return repository.obterDadosDashboard(filtros: filtros);
});

// Provider para os filtros atuais
final currentFiltersProvider = StateProvider<AppFilters>((ref) {
  return const AppFilters();
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilters = ref.watch(currentFiltersProvider);
    final dashboardDataAsync = ref.watch(dashboardDataProvider(currentFilters));

    return Scaffold(
      body: dashboardDataAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(error),
        data: (dashboardData) => _buildContent(dashboardData),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.heraldicBlue),
          ),
          SizedBox(height: 16),
          Text(
            'Carregando dados...',
            style: TextStyle(
              color: AppTheme.neutral400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorRed,
          ),
          const SizedBox(height: 16),
          const Text(
            'Erro ao carregar dados',
            style: TextStyle(
              color: AppTheme.errorRed,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              color: AppTheme.neutral400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(dashboardDataProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DashboardData dashboardData) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Header(
                  onExportCsv: () => _exportCsv(dashboardData),
                  onExportPdf: () => _exportPdf(dashboardData),
                );
              } else {
                return MobileHeader(
                  onExportCsv: () => _exportCsv(dashboardData),
                  onExportPdf: () => _exportPdf(dashboardData),
                );
              }
            },
          ),
        ),

        // Filtros
        SliverToBoxAdapter(
          child: FiltersBar(
            filterOptions: dashboardData.filterOptions,
            currentFilters: dashboardData.appliedFilters,
            onFiltersChanged: (newFilters) {
              ref.read(currentFiltersProvider.notifier).state = newFilters;
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // KPIs
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return KpiGrid(kpis: dashboardData.kpis);
              } else {
                return KpiHorizontalList(kpis: dashboardData.kpis);
              }
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),

        // Gráficos
        SliverToBoxAdapter(
          child: ChartsSection(
            seriesData: dashboardData.series,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),

        // Alertas
        SliverToBoxAdapter(
          child: AlertsPanel(
            alerts: dashboardData.alerts,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),

        // Footer
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return const Footer();
              } else {
                return const SimpleFooter();
              }
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  void _exportCsv(DashboardData dashboardData) {
    ExportService.exportarCsv(
      dashboardData.kpis,
      alertas: dashboardData.alerts,
      series: dashboardData.series,
    );

    // Mostrar feedback para o usuário
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_done, color: Colors.white),
            SizedBox(width: 8),
            Text('CSV exportado com sucesso!'),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportPdf(DashboardData dashboardData) {
    ExportService.exportarPdf(
      'Dashboard Cascavel em Números',
      kpis: dashboardData.kpis,
      alertas: dashboardData.alerts,
    );

    // Mostrar feedback para o usuário
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_done, color: Colors.white),
            SizedBox(width: 8),
            Text('PDF exportado com sucesso!'),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Widget para mostrar loading skeleton de toda a página
class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header skeleton
            SizedBox(height: 60),

            // Filters skeleton
            Card(
              child: SizedBox(height: 80),
            ),
            SizedBox(height: 24),

            // KPIs skeleton
            KpiGrid(kpis: [], isLoading: true),
            SizedBox(height: 40),

            // Charts skeleton
            ChartsSection(isLoading: true),
            SizedBox(height: 40),

            // Alerts skeleton
            AlertsPanel(alerts: [], isLoading: true),
          ],
        ),
      ),
    );
  }
}
