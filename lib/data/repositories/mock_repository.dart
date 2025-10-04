import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/kpi.dart';
import '../models/series.dart';
import '../models/alert.dart';
import '../models/filters.dart';

class MockRepository {
  static const String _mockDataPath = 'assets/mock_data.json';

  Map<String, dynamic>? _cachedData;

  // Carrega os dados mockados do arquivo JSON
  Future<Map<String, dynamic>> _loadMockData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_mockDataPath);
      _cachedData = json.decode(jsonString) as Map<String, dynamic>;
      return _cachedData!;
    } catch (e) {
      throw Exception('Erro ao carregar dados mockados: $e');
    }
  }

  // Opções disponíveis para filtros
  Future<FilterOptions> obterOpcoesFiltros() async {
    final data = await _loadMockData();
    final filtersData = data['filters'] as Map<String, dynamic>;
    var options = FilterOptions.fromJson(filtersData);

    // Tentativa opcional: carregar lista completa de bairros de um asset dedicado
    try {
      final raw = await rootBundle.loadString('assets/bairros_lista.json');
      final list = (json.decode(raw) as List<dynamic>).cast<String>();
      if (list.isNotEmpty) {
        options = FilterOptions(
          periodos: options.periodos,
          cnae: options.cnae,
          bairros: list,
        );
      }
    } catch (_) {
      // Ignora se o arquivo não existir ou estiver inválido
    }

    return options;
  }

  // KPIs
  Future<List<Kpi>> obterKpis() async {
    final data = await _loadMockData();
    final kpisData = data['kpis'] as List<dynamic>;
    return kpisData
        .map((kpiJson) => Kpi.fromJson(kpiJson as Map<String, dynamic>))
        .toList();
  }

  Future<Kpi?> obterKpiPorChave(String chave) async {
    final kpis = await obterKpis();
    try {
      return kpis.firstWhere((kpi) => kpi.chave == chave);
    } catch (_) {
      return null;
    }
  }

  // Séries temporais
  Future<SeriesData> obterSeries() async {
    final data = await _loadMockData();
    final seriesData = data['series'] as Map<String, dynamic>;
    return SeriesData.fromJson(seriesData);
  }

  Future<List<TimePoint>> obterSerieTemporalPorTipo(String tipo) async {
    final series = await obterSeries();
    switch (tipo.toLowerCase()) {
      case 'pib':
        return series.pib;
      case 'empregos_mensal':
      case 'empregos':
        return series.empregosMensal;
      default:
        return [];
    }
  }

  // CNAE
  Future<List<CnaeData>> obterDadosCnae() async {
    final series = await obterSeries();
    return series.admissoesPorCnae;
  }

  // Alertas
  Future<List<Alert>> obterAlertas() async {
    final data = await _loadMockData();
    final alertsData = data['alerts'] as List<dynamic>;
    return alertsData
        .map((alertJson) => Alert.fromJson(alertJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<Alert>> obterAlertasPorSeveridade(String severidade) async {
    final alerts = await obterAlertas();
    return alerts.where((alert) => alert.severidade == severidade).toList();
  }

  // Com filtros
  Future<List<Kpi>> obterKpisComFiltros(AppFilters filtros) async {
    // Sem fonte real, mantemos KPIs como estão.
    final all = await obterKpis();
    return all;
  }

  Future<SeriesData> obterSeriesComFiltros(AppFilters filtros) async {
    final base = await obterSeries();

    DateTime? inicio = filtros.dataInicial;
    DateTime? fim = filtros.dataFinal;

    // Se houver um período yyyy-MM selecionado, converte para intervalo mensal
    if (filtros.periodoSelecionado != null &&
        filtros.periodoSelecionado!.contains('-') &&
        filtros.periodoSelecionado!.length == 7) {
      final period = filtros.periodoSelecionado!; // yyyy-MM
      final parts = period.split('-');
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      if (year != null && month != null) {
        inicio = DateTime(year, month, 1);
        fim = DateTime(year, month + 1, 0);
      }
    }

    List<TimePoint> filtrarSerieMensal(List<TimePoint> serie) {
      if (inicio == null && fim == null) return serie;
      return serie.where((p) {
        final d = _parsePeriodoMensal(p.periodo);
        if (d == null) return true;
        final afterStart = (inicio == null)
            ? true
            : !d.isBefore(DateTime(inicio!.year, inicio!.month, inicio!.day));
        final beforeEnd = (fim == null)
            ? true
            : !d.isAfter(DateTime(fim!.year, fim!.month, fim!.day));
        return afterStart && beforeEnd;
      }).toList();
    }

    List<TimePoint> filtrarSerieAnual(List<TimePoint> serie) {
      if (inicio == null && fim == null) return serie;
      return serie.where((p) {
        final d = _parsePeriodoAnual(p.periodo);
        if (d == null) return true;
        final afterStart =
            (inicio == null) ? true : !d.isBefore(DateTime(inicio!.year, 1, 1));
        final beforeEnd =
            (fim == null) ? true : !d.isAfter(DateTime(fim!.year, 12, 31));
        return afterStart && beforeEnd;
      }).toList();
    }

    final empregosFiltrado = filtrarSerieMensal(base.empregosMensal);
    final pibFiltrado = filtrarSerieAnual(base.pib);

    final cnaeFiltrado = (filtros.cnaeSelecionado == null)
        ? base.admissoesPorCnae
        : base.admissoesPorCnae
            .where((e) => e.cnae == filtros.cnaeSelecionado)
            .toList();

    return SeriesData(
      pib: pibFiltrado,
      empregosMensal: empregosFiltrado,
      admissoesPorCnae: cnaeFiltrado,
    );
  }

  Future<List<Alert>> obterAlertasComFiltros(AppFilters filtros) async {
    // Sem metadados de data/bairro nos alertas mockados, retornamos todos
    return obterAlertas();
  }

  void limparCache() {
    _cachedData = null;
  }

  Future<void> simularDelayRede([int milissegundos = 500]) async {
    await Future.delayed(Duration(milliseconds: milissegundos));
  }

  // Agregador
  Future<DashboardData> obterDadosDashboard({AppFilters? filtros}) async {
    await simularDelayRede(300);

    final filterOptions = await obterOpcoesFiltros();
    final applied = filtros ?? const AppFilters();
    final kpis = await obterKpisComFiltros(applied);
    final series = await obterSeriesComFiltros(applied);
    final alerts = await obterAlertasComFiltros(applied);

    return DashboardData(
      filterOptions: filterOptions,
      kpis: kpis,
      series: series,
      alerts: alerts,
      appliedFilters: applied,
    );
  }

  // Helpers
  DateTime? _parsePeriodoMensal(String period) {
    try {
      if (period.length == 7 && period.contains('-')) {
        final parts = period.split('-');
        final y = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        return DateTime(y, m, 1);
      }
      if (period.length == 10 && period.contains('-')) {
        return DateTime.parse(period);
      }
    } catch (_) {}
    return null;
  }

  DateTime? _parsePeriodoAnual(String period) {
    try {
      if (period.length == 4) {
        final y = int.parse(period);
        return DateTime(y, 1, 1);
      }
    } catch (_) {}
    return null;
  }
}

// DTO agregado do dashboard
class DashboardData {
  final FilterOptions filterOptions;
  final List<Kpi> kpis;
  final SeriesData series;
  final List<Alert> alerts;
  final AppFilters appliedFilters;

  const DashboardData({
    required this.filterOptions,
    required this.kpis,
    required this.series,
    required this.alerts,
    required this.appliedFilters,
  });

  @override
  String toString() {
    return 'DashboardData(kpis: ${kpis.length}, alerts: ${alerts.length}, filters: $appliedFilters)';
  }
}
