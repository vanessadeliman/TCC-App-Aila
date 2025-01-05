class Celulas {
  String path;
  late Caixa caixa;
  double confianca;
  int indice;
  String nome;

  Celulas({
    this.path = '',
    Caixa? caixa,
    this.confianca = 0,
    this.indice = 0,
    this.nome = '',
  }) {
    this.caixa = caixa ?? Caixa();
  }

  factory Celulas.fromJson(Map<String, dynamic> json) {
    return Celulas(
      caixa: Caixa.fromJson(json['caixa']),
      confianca: json['confianca'] ?? 0,
      indice: json['indice'] ?? 0,
      nome: json['nome'] ?? '',
    );
  }
}

class Caixa {
  double x1;
  double x2;
  double y1;
  double y2;

  Caixa({
    this.x1 = 0,
    this.x2 = 0,
    this.y1 = 0,
    this.y2 = 0,
  });

  factory Caixa.fromJson(Map<String, dynamic> json) {
    return Caixa(
      x1: json['x1'] ?? 0,
      x2: json['x2'] ?? 0,
      y1: json['y1'] ?? 0,
      y2: json['y2'] ?? 0,
    );
  }
}
