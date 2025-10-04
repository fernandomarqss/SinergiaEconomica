class TimePoint {
  final String periodo;
  final double valor;

  const TimePoint({
    required this.periodo,
    required this.valor,
  });

  factory TimePoint.fromJson(Map<String, dynamic> json) {
    return TimePoint(
      periodo: json['period'] as String,
      valor: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': periodo,
      'value': valor,
    };
  }

  @override
  String toString() {
    return 'TimePoint(periodo: $periodo, valor: $valor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimePoint &&
        other.periodo == periodo &&
        other.valor == valor;
  }

  @override
  int get hashCode => Object.hash(periodo, valor);
}

class CnaeData {
  final String cnae;
  final double valor;
  final String? bairro;
  final String? periodo;

  const CnaeData({
    required this.cnae,
    required this.valor,
    this.bairro,
    this.periodo,
  });

  factory CnaeData.fromJson(Map<String, dynamic> json) {
    return CnaeData(
      cnae: json['cnae'] as String,
      valor: (json['value'] as num).toDouble(),
      bairro: json['bairro'] as String?,
      periodo: json['period'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cnae': cnae,
      'value': valor,
      if (bairro != null) 'bairro': bairro,
      if (periodo != null) 'period': periodo,
    };
  }

  @override
  String toString() {
    return 'CnaeData(cnae: $cnae, valor: $valor, bairro: $bairro, periodo: $periodo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CnaeData &&
        other.cnae == cnae &&
        other.valor == valor &&
        other.bairro == bairro &&
        other.periodo == periodo;
  }

  @override
  int get hashCode => Object.hash(cnae, valor, bairro, periodo);
}

class SeriesData {
  final List<TimePoint> pib;
  final List<TimePoint> empregosMensal;
  final List<CnaeData> admissoesPorCnae;

  const SeriesData({
    required this.pib,
    required this.empregosMensal,
    required this.admissoesPorCnae,
  });

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      pib: (json['pib'] as List<dynamic>)
          .map((e) => TimePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      empregosMensal: (json['empregos_mensal'] as List<dynamic>)
          .map((e) => TimePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      admissoesPorCnae: (json['admissoes_por_cnae'] as List<dynamic>)
          .map((e) => CnaeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pib': pib.map((e) => e.toJson()).toList(),
      'empregos_mensal': empregosMensal.map((e) => e.toJson()).toList(),
      'admissoes_por_cnae': admissoesPorCnae.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'SeriesData(pib: ${pib.length} points, empregosMensal: ${empregosMensal.length} points, admissoesPorCnae: ${admissoesPorCnae.length} points)';
  }
}
