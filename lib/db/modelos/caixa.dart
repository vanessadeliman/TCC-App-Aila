// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Celulas {
  int id;
  late Caixa caixa;
  double confianca;
  int indice;
  String nome;

  Celulas({
    this.id = 0,
    Caixa? caixa,
    this.confianca = 0,
    this.indice = 0,
    this.nome = '',
  }) {
    this.caixa = caixa ?? Caixa();
  }

  factory Celulas.fromMap(Map<String, dynamic> json) {
    return Celulas(
      caixa: json['caixa'] != null ? Caixa.fromMap(json['caixa']) : Caixa(),
      confianca: json['confianca'] ?? 0,
      indice: json['indice'] ?? 0,
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caixa': caixa.toMap(),
      'confianca': confianca,
      'indice': indice,
      'nome': nome,
    };
  }

  String toJson() => json.encode(toMap());

  factory Celulas.fromJson(String source) =>
      Celulas.fromMap(json.decode(source) as Map<String, dynamic>);
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

  factory Caixa.fromMap(Map<String, dynamic> json) {
    return Caixa(
      x1: json['x1'] ?? 0,
      x2: json['x2'] ?? 0,
      y1: json['y1'] ?? 0,
      y2: json['y2'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x1': x1,
      'x2': x2,
      'y1': y1,
      'y2': y2,
    };
  }

  String toJson() => json.encode(toMap());

  factory Caixa.fromJson(String source) =>
      Caixa.fromMap(json.decode(source) as Map<String, dynamic>);
}
