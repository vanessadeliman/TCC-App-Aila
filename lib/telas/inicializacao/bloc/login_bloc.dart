import 'package:aila/db/modelos/sessao.dart';
import 'package:aila/services/interceptor.dart';
import 'package:aila/telas/inicializacao/bloc/state_events_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  Sessao sessaoAtiva;
  InterceptedClient cliente = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(tempoRquisicao: 120),
    ],
    requestTimeout: const Duration(seconds: 120),
  );
  LoginBloc(this.sessaoAtiva) : super(InitState()) {
    on<AtualizaConexao>((event, emit) async {
      try {
        await cliente.get(Uri.parse('http://${event.ip}:${event.porta}/teste'));
        sessaoAtiva.ip = event.ip;
        sessaoAtiva.porta = event.porta;
        SharedPreferences cache = await SharedPreferences.getInstance();
        await cache.setString('sessaoAtiva', sessaoAtiva.toJson());
        event.callback();
      } catch (e) {
        if (e is ClientException) {
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(content: Text('Dados de conexão inválidos.')));
        } else {
          ScaffoldMessenger.of(event.context)
              .showSnackBar(const SnackBar(content: Text('Ocorreu um erro')));
        }
      }
    });
  }

}
