import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/filters.dart';

class FiltersBar extends StatelessWidget {
  final FilterOptions filterOptions;
  final AppFilters currentFilters;
  final Function(AppFilters) onFiltersChanged;

  const FiltersBar({
    super.key,
    required this.filterOptions,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return _buildDesktopFilters();
          } else {
            return _buildMobileFilters();
          }
        },
      ),
    );
  }

  Widget _buildDesktopFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.filter_list_outlined,
              color: AppTheme.heraldicBlue,
            ),
            const SizedBox(width: 8),
            const Text(
              'Filtros:',
              style: TextStyle(
                color: AppTheme.heraldicBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildPeriodDropdown(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCnaeDropdown(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBairroDropdown(),
                  ),
                  const SizedBox(width: 16),
                  _buildClearFiltersButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.filter_list_outlined,
                  color: AppTheme.heraldicBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Filtros',
                  style: TextStyle(
                    color: AppTheme.heraldicBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _buildClearFiltersButton(),
              ],
            ),
            const SizedBox(height: 16),
            _buildPeriodDropdown(),
            const SizedBox(height: 12),
            _buildCnaeDropdown(),
            const SizedBox(height: 12),
            _buildBairroDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Período',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: currentFilters.periodoSelecionado,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Todos os períodos'),
        ),
        ...filterOptions.periodos.map((period) {
          return DropdownMenuItem<String>(
            value: period,
            child: Text(Formatters.formatPeriod(period)),
          );
        }),
      ],
      onChanged: (value) {
        onFiltersChanged(currentFilters.copyWith(periodoSelecionado: value));
      },
    );
  }

  Widget _buildCnaeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'CNAE',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: currentFilters.cnaeSelecionado,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Todos os CNAEs'),
        ),
        ...filterOptions.cnae.map((cnae) {
          return DropdownMenuItem<String>(
            value: cnae,
            child: Text(Formatters.formatCnae(cnae)),
          );
        }),
      ],
      onChanged: (value) {
        onFiltersChanged(currentFilters.copyWith(cnaeSelecionado: value));
      },
    );
  }

  Widget _buildBairroDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Bairro',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: currentFilters.bairroSelecionado,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Todos os bairros'),
        ),
        ...filterOptions.bairros.map((bairro) {
          return DropdownMenuItem<String>(
            value: bairro,
            child: Text(bairro),
          );
        }),
      ],
      onChanged: (value) {
        onFiltersChanged(currentFilters.copyWith(bairroSelecionado: value));
      },
    );
  }

  Widget _buildClearFiltersButton() {
    final hasFilters = currentFilters.periodoSelecionado != null ||
        currentFilters.cnaeSelecionado != null ||
        currentFilters.bairroSelecionado != null;

    return TextButton.icon(
      onPressed: hasFilters ? () => onFiltersChanged(const AppFilters()) : null,
      icon: const Icon(Icons.clear_outlined, size: 16),
      label: const Text('Limpar'),
      style: TextButton.styleFrom(
        foregroundColor:
            hasFilters ? AppTheme.heraldicBlue : AppTheme.neutral400,
      ),
    );
  }
}
