class Kpi {
  final String chave;
  final String titulo;
  final double valor;
  final double variacao; // variação mensal
  final double variacaoAnual; // variação anual
  final String fonte;
  final String ultimaAtualizacao;

  const Kpi({
    required this.chave,
    required this.titulo,
    required this.valor,
    required this.variacao,
    required this.variacaoAnual,
    required this.fonte,
    required this.ultimaAtualizacao,
  });

  factory Kpi.fromJson(Map<String, dynamic> json) {
    return Kpi(
      chave: json['key'] as String,
      titulo: json['title'] as String,
      valor: (json['value'] as num).toDouble(),
      variacao: (json['delta_mom'] as num).toDouble(),
      variacaoAnual: (json['delta_yoy'] as num).toDouble(),
      fonte: json['source'] as String,
      ultimaAtualizacao: json['last_update'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': chave,
      'title': titulo,
      'value': valor,
      'delta_mom': variacao,
      'delta_yoy': variacaoAnual,
      'source': fonte,
      'last_update': ultimaAtualizacao,
    };
  }

  @override
  String toString() {
    return 'Kpi(chave: $chave, titulo: $titulo, valor: $valor, variacao: $variacao, variacaoAnual: $variacaoAnual)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Kpi &&
        other.chave == chave &&
        other.titulo == titulo &&
        other.valor == valor &&
        other.variacao == variacao &&
        other.variacaoAnual == variacaoAnual &&
        other.fonte == fonte &&
        other.ultimaAtualizacao == ultimaAtualizacao;
  }

  @override
  int get hashCode {
    return Object.hash(chave, titulo, valor, variacao, variacaoAnual, fonte,
        ultimaAtualizacao);
  }
}
