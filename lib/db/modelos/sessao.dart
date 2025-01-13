// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Sessao {
  String token;
  String cargo;
  String instituicao;
  String nome;
  String senha;
  String email;
  bool lembrar;
  String ip;
  String porta;
  Sessao({
    this.token = '',
    this.cargo = '',
    this.instituicao = '',
    this.nome = '',
    this.senha = '',
    this.email = '',
    this.ip = '',
    this.porta = '',
    this.lembrar = false,
  });

  String get path => "http://$ip:$porta/";

  Sessao copyWith(
      {String? token,
      String? cargo,
      String? ip,
      String? porta,
      String? instituicao,
      String? nome,
      String? email}) {
    return Sessao(
        token: token ?? this.token,
        cargo: cargo ?? this.cargo,
        instituicao: instituicao ?? this.instituicao,
        nome: nome ?? this.nome,
        ip: ip ?? this.ip,
        email: email ?? this.email);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'AcessToken': token,
      'cargo': cargo,
      'ip': ip,
      'porta': porta,
      'email': email,
      'instituicao': instituicao,
      'nome': nome,
      'lembrar': lembrar,
      'senha': senha
    };
  }

  Map<String, dynamic> toMapNovoCadastro() {
    return <String, dynamic>{
      'cargo': cargo,
      'instituicao': instituicao,
      'email': email,
      'nome': nome,
      'ip': ip,
      'porta': porta
    };
  }

  factory Sessao.fromMap(Map<String, dynamic> map) {
    return Sessao(
        token: map['AcessToken'] ?? '',
        ip: map['ip'] ?? '',
        porta: map['porta'] ?? '',
        cargo: map['cargo'] ?? '',
        instituicao: map['instituicao'] ?? '',
        nome: map['nome'] ?? '',
        lembrar: map['lembrar'] ?? false,
        senha: map['senha'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Sessao.fromJson(String source) =>
      Sessao.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sessao(token: $token, cargo: $cargo, instituicao: $instituicao, nome: $nome)';
  }

  @override
  bool operator ==(covariant Sessao other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.cargo == cargo &&
        other.instituicao == instituicao &&
        other.nome == nome;
  }

  @override
  int get hashCode {
    return token.hashCode ^
        cargo.hashCode ^
        instituicao.hashCode ^
        nome.hashCode;
  }
}
