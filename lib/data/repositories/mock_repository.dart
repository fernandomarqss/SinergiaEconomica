import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/kpi.dart';
import '../models/series.dart';
import '../models/alert.dart';
import '../models/filters.dart';

class MockRepository {
  static const String _mockDataPath = 'assets/mock_data.json';

  Map<String, dynamic>? _cachedData;

  /// Carrega os dados mockados do arquivo JSON
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

  /// Obtém as opções de filtros disponíveis
  Future<FilterOptions> obterOpcoesFiltros() async {
    final data = await _loadMockData();
    final filtersData = data['filters'] as Map<String, dynamic>;
    return FilterOptions.fromJson(filtersData);
  }

  /// Obtém todos os KPIs
  Future<List<Kpi>> obterKpis() async {
    final data = await _loadMockData();
    final kpisData = data['kpis'] as List<dynamic>;
    return kpisData
        .map((kpiJson) => Kpi.fromJson(kpiJson as Map<String, dynamic>))
        .toList();
  }

  /// Obtém um KPI específico por chave
  Future<Kpi?> obterKpiPorChave(String chave) async {
    final kpis = await obterKpis();
    try {
      return kpis.firstWhere((kpi) => kpi.chave == chave);
    } catch (e) {
      return null;
    }
  }

  /// Obtém todas as séries temporais
  Future<SeriesData> obterSeries() async {
    final data = await _loadMockData();
    final seriesData = data['series'] as Map<String, dynamic>;
    return SeriesData.fromJson(seriesData);
  }

  /// Obtém série temporal específica por tipo
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

  /// Obtém dados por CNAE
  Future<List<CnaeData>> obterDadosCnae() async {
    final series = await obterSeries();
    return series.admissoesPorCnae;
  }

  /// Obtém todos os alertas
  Future<List<Alert>> obterAlertas() async {
    final data = await _loadMockData();
    final alertsData = data['alerts'] as List<dynamic>;
    return alertsData
        .map((alertJson) => Alert.fromJson(alertJson as Map<String, dynamic>))
        .toList();
  }

  /// Obtém alertas filtrados por severidade
  Future<List<Alert>> obterAlertasPorSeveridade(String severidade) async {
    final alerts = await obterAlertas();
    return alerts.where((alert) => alert.severidade == severidade).toList();
  }

  /// Simula busca de dados com filtros aplicados
  /// No MVP, retorna os mesmos dados independente dos filtros
  Future<List<Kpi>> obterKpisComFiltros(AppFilters filtros) async {
    // TODO: Implementar lógica de filtros quando conectar com APIs reais
    // Por enquanto, retorna todos os KPIs
    return obterKpis();
  }

  /// Simula busca de séries com filtros aplicados
  Future<SeriesData> obterSeriesComFiltros(AppFilters filtros) async {
    // TODO: Implementar lógica de filtros quando conectar com APIs reais
    // Por enquanto, retorna todas as séries
    return obterSeries();
  }

  /// Simula busca de alertas com filtros aplicados
  Future<List<Alert>> obterAlertasComFiltros(AppFilters filtros) async {
    // TODO: Implementar lógica de filtros quando conectar com APIs reais
    // Por enquanto, retorna todos os alertas
    return obterAlertas();
  }

  /// Limpa cache de dados (útil para testes ou reload)
  void limparCache() {
    _cachedData = null;
  }

  /// Simula delay de rede para testes
  Future<void> simularDelayRede([int milissegundos = 500]) async {
    await Future.delayed(Duration(milliseconds: milissegundos));
  }

  /// Obtém dados completos do dashboard
  Future<DashboardData> obterDadosDashboard({AppFilters? filtros}) async {
    await simularDelayRede(300); // Simula carregamento

    final filterOptions = await obterOpcoesFiltros();
    final kpis = await obterKpis();
    final series = await obterSeries();
    final alerts = await obterAlertas();

    return DashboardData(
      filterOptions: filterOptions,
      kpis: kpis,
      series: series,
      alerts: alerts,
      appliedFilters: filtros ?? const AppFilters(),
    );
  }
}

/// Classe que encapsula todos os dados do dashboard
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
