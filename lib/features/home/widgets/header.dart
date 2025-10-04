import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/export_service.dart';

class Header extends StatelessWidget {
  final VoidCallback? onExportCsv;
  final VoidCallback? onExportPdf;

  const Header({
    super.key,
    this.onExportCsv,
    this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // Logo e título
          Expanded(
            child: Row(
              children: [
                // Ícone representando Cascavel
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.cascavelGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Título
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cascavel em Números',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppTheme.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Inteligência Econômica',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.heraldicBlue,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Ações de exportação
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onExportCsv ?? () => ExportService.exportarCsv([]),
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Exportar CSV'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.heraldicBlue,
                  side: const BorderSide(color: AppTheme.heraldicBlue),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed:
                    onExportPdf ?? () => ExportService.exportarPdf('Dashboard'),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Exportar PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cascavelGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MobileHeader extends StatelessWidget {
  final VoidCallback? onExportCsv;
  final VoidCallback? onExportPdf;

  const MobileHeader({
    super.key,
    this.onExportCsv,
    this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo e título
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.cascavelGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cascavel em Números',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.neutral900,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Inteligência Econômica',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.heraldicBlue,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Botões de exportação em mobile
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onExportCsv ?? () => ExportService.exportarCsv([]),
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text('CSV'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.heraldicBlue,
                    side: const BorderSide(color: AppTheme.heraldicBlue),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onExportPdf ??
                      () => ExportService.exportarPdf('Dashboard'),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  label: const Text('PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cascavelGreen,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
