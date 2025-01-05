// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:aila/db/modelos/caixa.dart';

class Coleta {
  int id;
  List<Celulas> celula;
  String path;
  Coleta({
    this.id = 0,
    this.celula = const [],
    this.path = '',
  });

  Coleta copyWith({
    List<Celulas>? celula,
    String? path,
  }) {
    return Coleta(
      celula: celula ?? this.celula,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'celula': celula.map((x) => x.toMap()).toList(),
      'path': path,
    };
  }

  factory Coleta.fromMap(Map<String, dynamic> map) {
    return Coleta(
      id: map["id"] ?? 0,
      celula: map['celulas'] != null
          ? List<Celulas>.from(
              (map['celulas'] as List<dynamic>).map<Celulas>(
                (x) => Celulas.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      path: map['path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Coleta.fromJson(String source) =>
      Coleta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Coleta(celula: $celula, path: $path)';

  @override
  bool operator ==(covariant Coleta other) {
    if (identical(this, other)) return true;

    return listEquals(other.celula, celula) && other.path == path;
  }

  @override
  int get hashCode => celula.hashCode ^ path.hashCode;
}
