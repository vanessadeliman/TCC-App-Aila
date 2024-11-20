// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Analise {
  int id;
  String nome;
  late DateTime data;
  int corados;
  int naoCorados;
  int totalCelulas;
  late List<String> imagem;
  bool favorito;
  num precisao;
  String observasoes;
  Analise({
    this.id = 0,
    this.nome = '',
    DateTime? data,
    this.corados = 0,
    this.naoCorados = 0,
    this.totalCelulas = 0,
    List<String>? imagem,
    this.favorito = false,
    this.precisao = 0,
    this.observasoes = '',
  }) {
    this.data = data ?? DateTime.now();
    this.imagem = imagem ?? [];
  }

  Analise copyWith({
    int? id,
    String? nome,
    DateTime? data,
    int? corados,
    int? naoCorados,
    int? totalCelulas,
    List<String>? imagem,
    bool? favorito,
    num? precisao,
    String? observasoes,
  }) {
    return Analise(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      data: data ?? this.data,
      corados: corados ?? this.corados,
      naoCorados: naoCorados ?? this.naoCorados,
      totalCelulas: totalCelulas ?? this.totalCelulas,
      imagem: imagem ?? this.imagem,
      favorito: favorito ?? this.favorito,
      precisao: precisao ?? this.precisao,
      observasoes: observasoes ?? this.observasoes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'data': data.toIso8601String(),
      'corados': corados,
      'nao_corados': naoCorados,
      'total_celulas': totalCelulas,
      'imagens': imagem.toString(),
      'favorito': favorito ? 1 : 0,
      'precisao': precisao,
      'observasoes': observasoes,
    };
  }

  factory Analise.fromMap(Map<String, dynamic> map) {
    List<String> imagens = [];
    if (map['imagens'] != null && map['imagens'] != '') {
      String img = map['imagens'];

      // Divide a string de imagens usando vírgulas
      imagens = img
          .substring(1, img.length - 1) // Remove os colchetes
          .split(',') // Divide a string pela vírgula
          .map((item) => item.trim()) // Remove espaços extras
          .toList();
    }
    return Analise(
      id: map['id'] ?? 0,
      nome: map['nome'] ?? '',
      data: map['data'] != null || map['data'] != ''
          ? DateTime.tryParse(map['data'])
          : null,
      corados: map['corados'] ?? 0,
      naoCorados: map['nao_corados'] ?? 0,
      totalCelulas: map['total_celulas'] ?? 0,
      imagem: imagens,
      favorito: map['favorito'] == 1,
      precisao: map['precisao'] ?? 0,
      observasoes: map['observasoes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Analise.fromJson(String source) =>
      Analise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Analise(id: $id, nome: $nome, data: $data, corados: $corados, nao_corados: $naoCorados, total_celulas: $totalCelulas, imagem: $imagem, favorito: $favorito, precisao: $precisao, observasoes: $observasoes)';
  }

  @override
  bool operator ==(covariant Analise other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nome == nome &&
        other.data == data &&
        other.corados == corados &&
        other.naoCorados == naoCorados &&
        other.totalCelulas == totalCelulas &&
        other.imagem == imagem &&
        other.favorito == favorito &&
        other.precisao == precisao &&
        other.observasoes == observasoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        data.hashCode ^
        corados.hashCode ^
        naoCorados.hashCode ^
        totalCelulas.hashCode ^
        imagem.hashCode ^
        favorito.hashCode ^
        precisao.hashCode ^
        observasoes.hashCode;
  }
}
