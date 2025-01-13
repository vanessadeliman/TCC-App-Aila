import 'dart:async';
import 'dart:convert';
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
    on<LogarEvent>(_login);
    on<CadastrarEvent>(_cadastro);
    on<AtualizaConexao>((event, emit) async {
      try {
        await cliente
            .get(Uri.parse('http://${event.ip}:${event.porta}/teste'));
        sessaoAtiva.ip = event.ip;
        sessaoAtiva.porta = event.porta;
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

  FutureOr<void> _login(LogarEvent event, emit) async {
    emit(CarregandoState());
    try {
      String credentials = '${event.email}:${event.senha}';
      String base64Credentials = base64Encode(utf8.encode(credentials));

      Map<String, String> headers = {
        'Authorization': 'Basic $base64Credentials',
      };

      final response = await cliente.get(
        Uri.parse('${sessaoAtiva.path}login'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        sessaoAtiva = Sessao.fromJson(response.body);
        sessaoAtiva.lembrar = event.lembrar;
        SharedPreferences cache = await SharedPreferences.getInstance();
        await cache.setString('sessaoAtiva', sessaoAtiva.toJson());
        emit(SucessoState());
      } else {
        final mensagem = jsonDecode(response.body);
        emit(ErroState(mensagem["message"]));
      }
    } catch (e) {
      emit(ErroState('Ocorreu um erro: ${e.toString()}'));
    }
  }

  FutureOr<void> _cadastro(CadastrarEvent event, emit) async {
    emit(CarregandoState());
    try {
      String credentials = '${event.email}:${event.senha}';
      String base64Credentials = base64Encode(utf8.encode(credentials));

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $base64Credentials',
      };

      sessaoAtiva.nome = event.nome;
      sessaoAtiva.cargo = event.cargo;
      sessaoAtiva.instituicao = event.instituicao;
      sessaoAtiva.lembrar = event.lembrar;
      sessaoAtiva.email = event.email;

      final response = await cliente.post(
          Uri.parse('${sessaoAtiva.path}cadastro'),
          headers: headers,
          body: jsonEncode(sessaoAtiva.toMapNovoCadastro()));

      if (response.statusCode == 200) {
        final map = jsonDecode(response.body);
        sessaoAtiva.token = map["AcessToken"];
        SharedPreferences cache = await SharedPreferences.getInstance();
        await cache.setString('sessaoAtiva', sessaoAtiva.toJson());
        emit(SucessoState());
      } else {
        final mensagem = jsonDecode(response.body);
        emit(ErroState(mensagem["message"]));
      }
    } catch (e) {
      emit(ErroState('Ocorreu um erro: ${e.toString()}'));
    }
  }
}
