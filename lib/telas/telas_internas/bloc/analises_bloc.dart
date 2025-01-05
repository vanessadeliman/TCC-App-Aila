import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:aila/db/modelos/caixa.dart';
import 'package:aila/db/modelos/sessao.dart';
import 'package:aila/services/interceptor.dart';
import 'package:aila/telas/telas_internas/bloc/state_events_analises.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;

class AnalisesBloc extends Bloc<AnalisesEvents, AnalisesState> {
  Sessao sessaoAtiva;
  InterceptedClient cliente = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(tempoRquisicao: 120),
    ],
    requestTimeout: const Duration(seconds: 120),
  );

  AnalisesBloc(this.sessaoAtiva) : super(InitState()) {
    on<EnviarAnaliseEvent>(_login);
  }

  FutureOr<void> _login(EnviarAnaliseEvent event, emit) async {
    emit(CarregandoState());
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${sessaoAtiva.token}',
      };

      for (var path in event.analise.imagem) {
        try {
          // Criação do multipart request
          final url =
              Uri.parse('https://tcc-servidor-aila.onrender.com/analise');

          var request = http.MultipartRequest('POST', url)
            ..headers.addAll(headers)
            ..files.add(await http.MultipartFile.fromPath('image', path));

          // Envio da requisição usando o cliente interno do InterceptedClient
          var streamedResponse = await cliente.send(request);

          // Convertendo a resposta stream em uma resposta completa
          var response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            // Decodificar o JSON
            final List<dynamic> data = jsonDecode(response.body);

            // Converter os dados para a classe modelo
            final List<Celulas> celulas = data.map((item) {
              return Celulas.fromJson(item)..path = path;
            }).toList();
            event.analise.celulas.add(celulas);
          }
        } catch (e) {
          log("Ocorreu um erro com a imagem: $path");
          throw Exception('Ocorreu um erro');
        }
      }
      final corado = event.analise.celulas
          .expand((sublist) => sublist)
          .where((celula) => celula.nome == "corado")
          .length;
      final naoCorado = event.analise.celulas
          .expand((sublist) => sublist)
          .where((celula) => celula.nome == "nao-corado")
          .length;
      event.analise.corados = corado;
      event.analise.naoCorados = naoCorado;
      emit(SucessoState(event.analise));
    } catch (e) {
      emit(ErroState('Ocorreu um erro: ${e.toString()}'));
    }
  }
}
