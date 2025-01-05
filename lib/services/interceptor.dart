import 'dart:developer';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  int tempoRquisicao;
  LoggingInterceptor({this.tempoRquisicao = 120});

  ///Método de interceptação de informações da requisição
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    log('------------------------------------------------ ');
    log('Request');
    log('\t- Método: ${request.method}');
    log('\t- Url: ${request.url}');
    log('\t- Headers: ${request.headers}');
    log('\t- Parametros: ${request.url.pathSegments}');
    if (request is Request) {
      log('\t- Body: ${(request).body}');
    }
    log('\t- Tempo: $tempoRquisicao');
    log('------------------------------------------------ ');
    return request;
  }

  ///Método de interceptação das informações da resposta
  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    log('------------------------------------------------ ');
    log('Response');
    log('\t- Serviço: ${response.request?.url ?? 'Sem Urlbase'}');
    log('\t- Status code: ${response.statusCode}');
    log('\t- Headers: ${response.headers}');   
    if (response is Response) {
      log('\t- Body: ${(response).body}');
    }
    log('------------------------------------------------ ');
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}
