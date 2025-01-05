// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:aila/db/modelos/coleta.dart';

class Analise {
  int id;
  String nome;
  late DateTime data;
  bool favorito;
  num precisao;
  String observasoes;
  List<Coleta> coletas;

  Analise(
      {this.id = 0,
      this.nome = '',
      DateTime? data,
      List<String>? imagem,
      this.favorito = false,
      this.precisao = 0,
      this.observasoes = '',
      this.coletas = const []}) {
    this.data = data ?? DateTime.now();
  }

  Analise copyWith({
    int? id,
    String? nome,
    DateTime? data,
    int? corados,
    int? naoCorados,
    int? totalCelulas,
    bool? favorito,
    num? precisao,
    List<Coleta>? coletas,
    String? observasoes,
  }) {
    return Analise(
      coletas: coletas ?? this.coletas,
      id: id ?? this.id,
      nome: nome ?? this.nome,
      data: data ?? this.data,
      favorito: favorito ?? this.favorito,
      precisao: precisao ?? this.precisao,
      observasoes: observasoes ?? this.observasoes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'data': data.toIso8601String(),
      'favorito': favorito ? 1 : 0,
      'precisao': precisao,
      'observasoes': observasoes,
    };
  }

  factory Analise.fromMap(Map<String, dynamic> map) {
    return Analise(
        id: map['id'] ?? 0,
        nome: map['nome'] ?? '',
        data: map['data'] != null || map['data'] != ''
            ? DateTime.tryParse(map['data'])
            : null,
        favorito: map['favorito'] == 1,
        precisao: map['precisao'] ?? 0,
        observasoes: map['observasoes'] ?? '',
        coletas: map['coletas'] != null
            ? List<Coleta>.from(
                (map['coletas'] as List<dynamic>).map<Coleta>(
                  (x) => Coleta.fromMap(x as Map<String, dynamic>),
                ),
              )
            : []);
  }

  String toJson() => json.encode(toMap());

  factory Analise.fromJson(String source) =>
      Analise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Analise(id: $id, nome: $nome, data: $data, favorito: $favorito, precisao: $precisao, observasoes: $observasoes)';
  }

  @override
  bool operator ==(covariant Analise other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nome == nome &&
        other.data == data &&
        other.favorito == favorito &&
        other.precisao == precisao &&
        other.observasoes == observasoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        data.hashCode ^
        favorito.hashCode ^
        precisao.hashCode ^
        observasoes.hashCode;
  }
}
