import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alert.dart';

class AlertsPanel extends StatelessWidget {
  final List<Alert> alerts;
  final bool isLoading;

  const AlertsPanel({
    super.key,
    required this.alerts,
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
                Icons.warning_amber_outlined,
                color: AppTheme.heraldicBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Alertas e Tendências',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.heraldicBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (alerts.isNotEmpty && !isLoading) _buildSeverityLegend(),
            ],
          ),
          const SizedBox(height: 20),

          // Lista de alertas
          if (isLoading)
            _buildLoadingState()
          else if (alerts.isEmpty)
            _buildEmptyState()
          else
            _buildAlertsList(),
        ],
      ),
    );
  }

  Widget _buildSeverityLegend() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLegendItem('Alto', AppTheme.errorRed),
        const SizedBox(width: 12),
        _buildLegendItem('Médio', AppTheme.warningOrange),
        const SizedBox(width: 12),
        _buildLegendItem('Baixo', AppTheme.successGreen),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.neutral400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAlertSkeleton(),
        ),
      ),
    );
  }

  Widget _buildAlertSkeleton() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.neutral400.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.neutral400.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.neutral400.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        child: const Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppTheme.successGreen,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum alerta no momento',
              style: TextStyle(
                color: AppTheme.successGreen,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Todos os indicadores estão dentro dos parâmetros esperados',
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

  Widget _buildAlertsList() {
    // Agrupar alertas por severidade
    final groupedAlerts = <String, List<Alert>>{};
    for (final alert in alerts) {
      groupedAlerts.putIfAbsent(alert.severidade, () => []).add(alert);
    }

    // Ordenar severidades (high, medium, low)
    final severityOrder = ['high', 'medium', 'low'];
    final sortedGroups = severityOrder
        .where((severity) => groupedAlerts.containsKey(severity))
        .toList();

    return Column(
      children: sortedGroups.map((severity) {
        final severityAlerts = groupedAlerts[severity]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sortedGroups.length > 1) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.getSeverityColor(severity),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getSeverityLabel(severity),
                      style: const TextStyle(
                        color: AppTheme.heraldicBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ...severityAlerts.map((alert) => _buildAlertCard(alert)),
            if (severity != sortedGroups.last) const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    final severityColor = AppTheme.getSeverityColor(alert.severidade);
    final severityIcon = _getSeverityIcon(alert.severidade);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: severityColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícone de severidade
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  severityIcon,
                  color: severityColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),

              // Conteúdo do alerta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo do alerta
                    Text(
                      _formatAlertType(alert.tipo),
                      style: TextStyle(
                        color: severityColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Mensagem do alerta
                    Text(
                      alert.mensagem,
                      style: const TextStyle(
                        color: AppTheme.neutral900,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge de severidade
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: severityColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _getSeverityLabel(alert.severidade),
                  style: TextStyle(
                    color: severityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSeverityLabel(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return 'Alto';
      case 'medium':
        return 'Médio';
      case 'low':
        return 'Baixo';
      default:
        return 'Info';
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.error_outline;
      case 'medium':
        return Icons.warning_amber_outlined;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatAlertType(String type) {
    // Converter snake_case para título
    return type
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}
