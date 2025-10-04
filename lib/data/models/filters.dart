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

  const AppFilters({
    this.periodoSelecionado,
    this.cnaeSelecionado,
    this.bairroSelecionado,
  });

  AppFilters copyWith({
    String? periodoSelecionado,
    String? cnaeSelecionado,
    String? bairroSelecionado,
  }) {
    return AppFilters(
      periodoSelecionado: periodoSelecionado ?? this.periodoSelecionado,
      cnaeSelecionado: cnaeSelecionado ?? this.cnaeSelecionado,
      bairroSelecionado: bairroSelecionado ?? this.bairroSelecionado,
    );
  }

  @override
  String toString() {
    return 'AppFilters(periodo: $periodoSelecionado, cnae: $cnaeSelecionado, bairro: $bairroSelecionado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppFilters &&
        other.periodoSelecionado == periodoSelecionado &&
        other.cnaeSelecionado == cnaeSelecionado &&
        other.bairroSelecionado == bairroSelecionado;
  }

  @override
  int get hashCode =>
      Object.hash(periodoSelecionado, cnaeSelecionado, bairroSelecionado);
}
