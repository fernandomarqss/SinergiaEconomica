import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/kpi.dart';
import 'kpi_card.dart';

class KpiGrid extends StatelessWidget {
  final List<Kpi> kpis;
  final bool isLoading;

  const KpiGrid({
    super.key,
    required this.kpis,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          Row(
            children: [
              const Icon(
                Icons.dashboard_outlined,
                color: AppTheme.heraldicBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Indicadores Principais',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.heraldicBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 16),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.heraldicBlue),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Grid de KPIs
          LayoutBuilder(
            builder: (context, constraints) {
              return _buildResponsiveGrid(context, constraints);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveGrid(
      BuildContext context, BoxConstraints constraints) {
    int crossAxisCount;
    double childAspectRatio;
    bool isCompact;

    // Determinar layout baseado na largura
    if (constraints.maxWidth > 1200) {
      // Desktop large
      crossAxisCount = 4;
      childAspectRatio = 1.3;
      isCompact = false;
    } else if (constraints.maxWidth > 900) {
      // Desktop medium
      crossAxisCount = 3;
      childAspectRatio = 1.2;
      isCompact = false;
    } else if (constraints.maxWidth > 600) {
      // Tablet
      crossAxisCount = 2;
      childAspectRatio = 1.1;
      isCompact = true;
    } else {
      // Mobile
      crossAxisCount = 1;
      childAspectRatio = 2.5;
      isCompact = true;
    }

    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 8, // Número de skeletons
        itemBuilder: (context, index) {
          return KpiCardSkeleton(isCompact: isCompact);
        },
      );
    }

    if (kpis.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return KpiCard(
          kpi: kpis[index],
          isCompact: isCompact,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 64,
              color: AppTheme.neutral400,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum indicador encontrado',
              style: TextStyle(
                color: AppTheme.neutral400,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros para ver os dados',
              style: TextStyle(
                color: AppTheme.neutral400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget especializado para mostrar KPIs em uma única linha (mobile)
class KpiHorizontalList extends StatelessWidget {
  final List<Kpi> kpis;
  final bool isLoading;

  const KpiHorizontalList({
    super.key,
    required this.kpis,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          Row(
            children: [
              const Icon(
                Icons.dashboard_outlined,
                color: AppTheme.heraldicBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Indicadores',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.heraldicBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista horizontal
          SizedBox(
            height: 140,
            child: isLoading ? _buildLoadingList() : _buildKpiList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: 12),
          child: const KpiCardSkeleton(isCompact: true),
        );
      },
    );
  }

  Widget _buildKpiList() {
    if (kpis.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum indicador disponível',
          style: TextStyle(color: AppTheme.neutral400),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: 12),
          child: KpiCard(
            kpi: kpis[index],
            isCompact: true,
          ),
        );
      },
    );
  }
}
