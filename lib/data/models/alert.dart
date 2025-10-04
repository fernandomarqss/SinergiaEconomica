class Alert {
  final String tipo;
  final String mensagem;
  final String severidade;

  const Alert({
    required this.tipo,
    required this.mensagem,
    required this.severidade,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      tipo: json['type'] as String,
      mensagem: json['message'] as String,
      severidade: json['severity'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': tipo,
      'message': mensagem,
      'severity': severidade,
    };
  }

  @override
  String toString() {
    return 'Alert(tipo: $tipo, mensagem: $mensagem, severidade: $severidade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Alert &&
        other.tipo == tipo &&
        other.mensagem == mensagem &&
        other.severidade == severidade;
  }

  @override
  int get hashCode => Object.hash(tipo, mensagem, severidade);
}
