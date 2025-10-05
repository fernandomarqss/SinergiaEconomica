import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/series.dart';

class ChartsSection extends StatelessWidget {
  final SeriesData? seriesData;
  final bool isLoading;

  const ChartsSection({
    super.key,
    this.seriesData,
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
                Icons.show_chart_outlined,
                color: AppTheme.heraldicBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Análise Temporal',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.heraldicBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Gráficos
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return _buildDesktopCharts();
              } else {
                return _buildMobileCharts();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCharts() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildTimeSeriesChart(),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: _buildCnaeBarChart(),
        ),
      ],
    );
  }

  Widget _buildMobileCharts() {
    return Column(
      children: [
        _buildTimeSeriesChart(),
        const SizedBox(height: 20),
        _buildCnaeBarChart(),
      ],
    );
  }

  Widget _buildTimeSeriesChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evolução do PIB Municipal',
              style: TextStyle(
                color: AppTheme.heraldicBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: isLoading ? _buildChartSkeleton() : _buildLineChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCnaeBarChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admissões por CNAE',
              style: TextStyle(
                color: AppTheme.heraldicBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: isLoading ? _buildChartSkeleton() : _buildBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    if (seriesData == null || seriesData!.pib.isEmpty) {
      return _buildEmptyChart('Nenhum dado de PIB disponível');
    }

    final spots = seriesData!.pib.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.valor);
    }).toList();

    final maxY =
        seriesData!.pib.map((e) => e.valor).reduce((a, b) => a > b ? a : b);
    final minY =
        seriesData!.pib.map((e) => e.valor).reduce((a, b) => a < b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxY - minY) / 4,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.neutral400.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: AppTheme.neutral400.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < seriesData!.pib.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      seriesData!.pib[index].periodo,
                      style: const TextStyle(
                        color: AppTheme.neutral400,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 4,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    Formatters.formatNumber(value),
                    style: const TextStyle(
                      color: AppTheme.neutral400,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppTheme.neutral400.withValues(alpha: 0.3)),
        ),
        minX: 0,
        maxX: (seriesData!.pib.length - 1).toDouble(),
        minY: minY * 0.95,
        maxY: maxY * 1.05,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.heraldicBlue,
                AppTheme.heraldicBlue.withValues(alpha: 0.8),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.crownGold,
                  strokeWidth: 2,
                  strokeColor: AppTheme.heraldicBlue,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.heraldicBlue.withValues(alpha: 0.2),
                  AppTheme.heraldicBlue.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppTheme.neutral900.withValues(alpha: 0.9),
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < seriesData!.pib.length) {
                  final point = seriesData!.pib[index];
                  return LineTooltipItem(
                    '${point.periodo}\n${Formatters.formatCurrency(point.valor)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    if (seriesData == null || seriesData!.admissoesPorCnae.isEmpty) {
      return _buildEmptyChart('Nenhum dado de CNAE disponível');
    }

    final maxY = seriesData!.admissoesPorCnae
        .map((e) => e.valor)
        .reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppTheme.neutral900.withValues(alpha: 0.9),
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final cnaeData = seriesData!.admissoesPorCnae[groupIndex];
              return BarTooltipItem(
                '${Formatters.formatCnae(cnaeData.cnae)}\n${Formatters.formatNumber(cnaeData.valor)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < seriesData!.admissoesPorCnae.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        seriesData!.admissoesPorCnae[index].cnae,
                        style: const TextStyle(
                          color: AppTheme.neutral400,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    Formatters.formatNumber(value),
                    style: const TextStyle(
                      color: AppTheme.neutral400,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppTheme.neutral400.withValues(alpha: 0.3)),
        ),
        barGroups: seriesData!.admissoesPorCnae.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.valor,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.cascavelGreen,
                    AppTheme.cascavelGreen.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.neutral400.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutral400.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.heraldicBlue),
        ),
      ),
    );
  }

  Widget _buildEmptyChart(String message) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.neutral400.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: AppTheme.neutral400,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
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
