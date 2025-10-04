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

  // KPIs com filtros
  Future<List<Kpi>> obterKpisComFiltros(AppFilters filtros) async {
    final data = await _loadMockData();

    // Se não há filtros específicos, retorna KPIs gerais
    if (filtros.cnaeSelecionado == null && filtros.bairroSelecionado == null) {
      final kpisData = data['kpis'] as List<dynamic>;
      return kpisData
          .map((kpiJson) => Kpi.fromJson(kpiJson as Map<String, dynamic>))
          .toList();
    }

    // Se há filtro CNAE, retorna KPIs específicos do CNAE
    if (filtros.cnaeSelecionado != null) {
      final kpisPorCnae = data['kpis_por_cnae'] as Map<String, dynamic>?;
      if (kpisPorCnae != null &&
          kpisPorCnae.containsKey(filtros.cnaeSelecionado)) {
        final kpisData = kpisPorCnae[filtros.cnaeSelecionado] as List<dynamic>;
        return kpisData
            .map((kpiJson) => Kpi.fromJson(kpiJson as Map<String, dynamic>))
            .toList();
      }
    }

    // Se há filtro Bairro, retorna KPIs específicos do bairro
    if (filtros.bairroSelecionado != null) {
      final kpisPorBairro = data['kpis_por_bairro'] as Map<String, dynamic>?;
      if (kpisPorBairro != null &&
          kpisPorBairro.containsKey(filtros.bairroSelecionado)) {
        final kpisData =
            kpisPorBairro[filtros.bairroSelecionado] as List<dynamic>;
        return kpisData
            .map((kpiJson) => Kpi.fromJson(kpiJson as Map<String, dynamic>))
            .toList();
      }
    }

    // Fallback para KPIs gerais
    final kpisData = data['kpis'] as List<dynamic>;
    return kpisData
        .map((kpiJson) => Kpi.fromJson(kpiJson as Map<String, dynamic>))
        .toList();
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

    if (inicio != null && fim != null && inicio.isAfter(fim)) {
      final temp = inicio;
      inicio = fim;
      fim = temp;
    }

    List<TimePoint> filtrarSerieMensal(List<TimePoint> serie) {
      if (inicio == null && fim == null) return serie;
      return serie.where((p) {
        final d = _parsePeriodoMensal(p.periodo);
        if (d == null) return true;
        final afterStart = (inicio == null)
            ? true
            : !d.isBefore(DateTime(inicio.year, inicio.month, inicio.day));
        final beforeEnd = (fim == null)
            ? true
            : !d.isAfter(DateTime(fim.year, fim.month, fim.day));
        return afterStart && beforeEnd;
      }).toList();
    }

    final empregosFiltrado = filtrarSerieMensal(base.empregosMensal);
    final pibFiltrado = base.pib;

    final cnaeFiltrado = _obterTopCnaes(
      base.admissoesPorCnae,
      filtros,
      inicio,
      fim,
    );

    return SeriesData(
      pib: pibFiltrado,
      empregosMensal: empregosFiltrado,
      admissoesPorCnae: cnaeFiltrado,
    );
  }

  Future<List<Alert>> obterAlertasComFiltros(AppFilters filtros) async {
    final data = await _loadMockData();
    final alertsData = data['alerts'] as List<dynamic>;
    final allAlerts = alertsData
        .map((alertJson) => Alert.fromJson(alertJson as Map<String, dynamic>))
        .toList();

    // Filtrar alertas por CNAE ou bairro se especificados
    return allAlerts.where((alert) {
      // Se há filtro CNAE, só mostra alertas relacionados ao CNAE
      if (filtros.cnaeSelecionado != null) {
        final alertData = alertsData.firstWhere(
          (a) => a['message'] == alert.mensagem,
          orElse: () => <String, dynamic>{},
        );
        final alertCnae = alertData['cnae'] as String?;
        if (alertCnae != null && alertCnae != filtros.cnaeSelecionado) {
          return false;
        }
      }

      // Se há filtro Bairro, só mostra alertas relacionados ao bairro
      if (filtros.bairroSelecionado != null) {
        final alertData = alertsData.firstWhere(
          (a) => a['message'] == alert.mensagem,
          orElse: () => <String, dynamic>{},
        );
        final alertBairro = alertData['bairro'] as String?;
        if (alertBairro != null && alertBairro != filtros.bairroSelecionado) {
          return false;
        }
      }

      return true;
    }).toList();
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

  List<CnaeData> _obterTopCnaes(
    List<CnaeData> dados,
    AppFilters filtros,
    DateTime? inicio,
    DateTime? fim, {
    int limite = 10,
  }) {
    DateTime? start = inicio;
    DateTime? end = fim;

    if (start != null && end != null && start.isAfter(end)) {
      final temp = start;
      start = end;
      end = temp;
    }

    if (start != null && end == null) {
      end = _endOfMonth(start);
    } else if (start == null && end != null) {
      start = _startOfMonth(end);
    }

    if (start == null && end == null) {
      final periods = dados
          .map((e) => e.periodo)
          .whereType<String>()
          .map(_parsePeriodoMensal)
          .whereType<DateTime>()
          .toList();
      if (periods.isNotEmpty) {
        periods.sort();
        final latest = periods.last;
        start = DateTime(latest.year, 1, 1);
        end = DateTime(latest.year, 12, 31);
      }
    }

    final normalizedStart = start != null ? _startOfMonth(start) : null;
    final normalizedEnd = end != null ? _endOfMonth(end) : null;

    final filtered = dados.where((item) {
      if (filtros.cnaeSelecionado != null &&
          item.cnae != filtros.cnaeSelecionado) {
        return false;
      }
      if (filtros.bairroSelecionado != null &&
          item.bairro != filtros.bairroSelecionado) {
        return false;
      }

      if (item.periodo != null) {
        final date = _parsePeriodoMensal(item.periodo!);
        if (normalizedStart != null &&
            date != null &&
            date.isBefore(normalizedStart)) {
          return false;
        }
        if (normalizedEnd != null &&
            date != null &&
            date.isAfter(normalizedEnd)) {
          return false;
        }
      }

      return true;
    }).toList();

    if (filtered.isEmpty) {
      return [];
    }

    final Map<String, double> acumuladoPorCnae = {};
    for (final item in filtered) {
      acumuladoPorCnae[item.cnae] =
          (acumuladoPorCnae[item.cnae] ?? 0) + item.valor;
    }

    final ordenado = acumuladoPorCnae.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ordenado.take(limite).map((entry) {
      return CnaeData(
        cnae: entry.key,
        valor: entry.value,
        periodo: normalizedStart != null &&
                normalizedEnd != null &&
                normalizedStart.year == normalizedEnd.year
            ? normalizedStart.year.toString()
            : null,
      );
    }).toList();
  }

  DateTime _startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

  DateTime _endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);
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
