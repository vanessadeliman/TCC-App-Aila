import 'package:aila/db/modelos/analise.dart';

abstract class AnalisesState {}

class InitState extends AnalisesState {}

class CarregandoState extends AnalisesState {}

class SucessoState extends AnalisesState {
  final Analise analise;
  SucessoState(this.analise);
}

class ErroState extends AnalisesState {
  final String erro;
  ErroState(this.erro);
}

abstract class AnalisesEvents {}

class EnviarAnaliseEvent extends AnalisesEvents {
  final Analise analise;
  final void Function()? callback;
  EnviarAnaliseEvent(this.analise, {this.callback});
}
