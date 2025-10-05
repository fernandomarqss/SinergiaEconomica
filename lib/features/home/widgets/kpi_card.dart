import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/kpi.dart';

class KpiCard extends StatelessWidget {
  final Kpi kpi;
  final bool isCompact;

  const KpiCard({
    super.key,
    required this.kpi,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do KPI
            Text(
              kpi.titulo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.heraldicBlue,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isCompact ? 8 : 12),

            // Valor principal
            Text(
              Formatters.formatKpiValue(kpi.chave, kpi.valor),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.neutral900,
                    fontWeight: FontWeight.bold,
                    fontSize: isCompact ? 20 : 24,
                  ),
            ),
            SizedBox(height: isCompact ? 8 : 12),

            // Variações
            Row(
              children: [
                Expanded(
                  child: _buildDeltaChip(
                    label: 'M/M',
                    value: kpi.variacao,
                    isCompact: isCompact,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDeltaChip(
                    label: 'A/A',
                    value: kpi.variacaoAnual,
                    isCompact: isCompact,
                  ),
                ),
              ],
            ),

            if (!isCompact) ...[
              const SizedBox(height: 12),
              // Fonte e última atualização
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fonte: ${kpi.fonte}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutral400,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Atualizado: ${_formatUpdateDate(kpi.ultimaAtualizacao)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutral400,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeltaChip({
    required String label,
    required double value,
    required bool isCompact,
  }) {
    final color = AppTheme.getDeltaColor(value);
    final icon = value > 0
        ? Icons.trending_up
        : value < 0
            ? Icons.trending_down
            : Icons.trending_flat;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 12 : 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label ${Formatters.formatPercent(value)}',
              style: TextStyle(
                color: color,
                fontSize: isCompact ? 10 : 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatUpdateDate(String dateString) {
    final date = Formatters.parseDate(dateString);
    if (date != null) {
      return Formatters.formatDate(date);
    }
    return dateString;
  }
}

class KpiCardSkeleton extends StatelessWidget {
  final bool isCompact;

  const KpiCardSkeleton({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título placeholder
            Container(
              height: isCompact ? 16 : 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.neutral400.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: isCompact ? 8 : 12),

            // Valor placeholder
            Container(
              height: isCompact ? 20 : 24,
              width: 120,
              decoration: BoxDecoration(
                color: AppTheme.neutral400.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: isCompact ? 8 : 12),

            // Chips placeholder
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: isCompact ? 24 : 28,
                    decoration: BoxDecoration(
                      color: AppTheme.neutral400.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: isCompact ? 24 : 28,
                    decoration: BoxDecoration(
                      color: AppTheme.neutral400.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),

            if (!isCompact) ...[
              const SizedBox(height: 12),
              Container(
                height: 12,
                width: 100,
                decoration: BoxDecoration(
                  color: AppTheme.neutral400.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 12,
                width: 80,
                decoration: BoxDecoration(
                  color: AppTheme.neutral400.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
