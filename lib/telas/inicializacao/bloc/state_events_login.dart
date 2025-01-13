import 'package:flutter/widgets.dart';

abstract class LoginState {}

class InitState extends LoginState {}

class CarregandoState extends LoginState {}

class SucessoState extends LoginState {}

class ErroState extends LoginState {
  final String erro;
  ErroState(this.erro);
}

abstract class LoginEvents {}

class AtualizaConexao extends LoginEvents {
  final BuildContext context;
  final String ip;
  final String porta;
  final Function callback;
  AtualizaConexao(this.context, this.ip, this.porta, this.callback);
}

class LogarEvent extends LoginEvents {
  final String email;
  final String senha;
  final bool lembrar;
  LogarEvent(this.email, this.senha, this.lembrar);
}

class CadastrarEvent extends LoginEvents {
  final String email;
  final String senha;
  final String cargo;
  final String instituicao;
  final String nome;
  final bool lembrar;
  CadastrarEvent(
      {required this.email,
      required this.senha,
      required this.cargo,
      required this.instituicao,
      required this.nome,
      required this.lembrar});
}
