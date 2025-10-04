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
            return _buildDesktopFilters(context);
          } else {
            return _buildMobileFilters(context);
          }
        },
      ),
    );
  }

  Widget _buildDesktopFilters(BuildContext context) {
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
                  _buildDateField(context: context, label: 'Data inicial', isStart: true),
                  const SizedBox(width: 12),
                  _buildDateField(context: context, label: 'Data final', isStart: false),
                  const SizedBox(width: 16),
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

  Widget _buildMobileFilters(BuildContext context) {
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
            _buildDateField(context: context, label: 'Data inicial', isStart: true),
            const SizedBox(height: 12),
            _buildDateField(context: context, label: 'Data final', isStart: false),
            const SizedBox(height: 12),
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
      value: currentFilters.dataInicial != null || currentFilters.dataFinal != null
          ? null
          : currentFilters.periodoSelecionado,
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
      onChanged: (currentFilters.dataInicial != null || currentFilters.dataFinal != null)
          ? null
          : (value) {
              onFiltersChanged(
                currentFilters.copyWith(
                  periodoSelecionado: value,
                ),
              );
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
        currentFilters.bairroSelecionado != null ||
        currentFilters.dataInicial != null ||
        currentFilters.dataFinal != null;

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

  Widget _buildDateField({required BuildContext context, required String label, required bool isStart}) {
    final DateTime? value = isStart ? currentFilters.dataInicial : currentFilters.dataFinal;

    return SizedBox(
      width: 190,
      child: InkWell(
        onTap: () async {
          final initialDate = value ?? DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            helpText: label,
          );

          if (picked != null) {
            if (isStart) {
              onFiltersChanged(
                currentFilters.copyWith(
                  dataInicial: picked,
                  // limpar período selecionado ao usar datas
                  periodoSelecionado: null,
                ),
              );
            } else {
              onFiltersChanged(
                currentFilters.copyWith(
                  dataFinal: picked,
                  periodoSelecionado: null,
                ),
              );
            }
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            suffixIcon: const Icon(Icons.date_range_outlined, size: 18),
          ),
          child: Text(
            value != null ? Formatters.formatDate(value) : 'DD/MM/AAAA',
            style: TextStyle(
              color: value != null ? AppTheme.neutral900 : AppTheme.neutral400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
