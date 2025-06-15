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