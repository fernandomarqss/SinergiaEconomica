class FilterOptions {
  final List<String> periodos;
  final List<String> cnae;
  final List<String> bairros;

  const FilterOptions({
    required this.periodos,
    required this.cnae,
    required this.bairros,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      periodos: List<String>.from(json['periods'] as List),
      cnae: List<String>.from(json['cnae'] as List),
      bairros: List<String>.from(json['bairros'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periods': periodos,
      'cnae': cnae,
      'bairros': bairros,
    };
  }

  @override
  String toString() {
    return 'FilterOptions(periodos: ${periodos.length}, cnae: ${cnae.length}, bairros: ${bairros.length})';
  }
}

class AppFilters {
  final String? periodoSelecionado;
  final String? cnaeSelecionado;
  final String? bairroSelecionado;
  final DateTime? dataInicial;
  final DateTime? dataFinal;

  static const Object _undefined = Object();

  const AppFilters({
    this.periodoSelecionado,
    this.cnaeSelecionado,
    this.bairroSelecionado,
    this.dataInicial,
    this.dataFinal,
  });

  AppFilters copyWith({
    Object? periodoSelecionado = _undefined,
    Object? cnaeSelecionado = _undefined,
    Object? bairroSelecionado = _undefined,
    Object? dataInicial = _undefined,
    Object? dataFinal = _undefined,
  }) {
    return AppFilters(
      periodoSelecionado: identical(periodoSelecionado, _undefined)
          ? this.periodoSelecionado
          : periodoSelecionado as String?,
      cnaeSelecionado: identical(cnaeSelecionado, _undefined)
          ? this.cnaeSelecionado
          : cnaeSelecionado as String?,
      bairroSelecionado: identical(bairroSelecionado, _undefined)
          ? this.bairroSelecionado
          : bairroSelecionado as String?,
      dataInicial: identical(dataInicial, _undefined)
          ? this.dataInicial
          : dataInicial as DateTime?,
      dataFinal: identical(dataFinal, _undefined)
          ? this.dataFinal
          : dataFinal as DateTime?,
    );
  }

  @override
  String toString() {
    return 'AppFilters(periodo: $periodoSelecionado, cnae: $cnaeSelecionado, bairro: $bairroSelecionado, dataInicial: $dataInicial, dataFinal: $dataFinal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppFilters &&
        other.periodoSelecionado == periodoSelecionado &&
        other.cnaeSelecionado == cnaeSelecionado &&
        other.bairroSelecionado == bairroSelecionado &&
        other.dataInicial == dataInicial &&
        other.dataFinal == dataFinal;
  }

  @override
  int get hashCode => Object.hash(periodoSelecionado, cnaeSelecionado,
      bairroSelecionado, dataInicial, dataFinal);
}
