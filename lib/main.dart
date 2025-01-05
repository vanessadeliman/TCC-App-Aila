import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/db/modelos/sessao.dart';
import 'package:aila/telas/apresentacao.dart';
import 'package:aila/telas/telas_internas/bloc/analises_bloc.dart';
import 'package:aila/telas/telas_internas/home.dart';
import 'package:aila/telas/inicializacao/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<Map<String, dynamic>> resultados =
      await DatabaseConexao().getAnalises();

  final List<Analise> analises =
      List.from(resultados.map((element) => Analise.fromMap(element)));

  SharedPreferences cache = await SharedPreferences.getInstance();
  final sessaoCache = cache.getString('sessaoAtiva');
  Sessao sessaoAtiva = Sessao();
  if (sessaoCache != null && sessaoCache.isNotEmpty) {
    sessaoAtiva = Sessao.fromJson(sessaoCache);

    DateTime? expirationDate = Jwt.getExpiryDate(sessaoAtiva.token);

    if (expirationDate != null) {
      if (!DateTime.now().isBefore(expirationDate)) {
        sessaoAtiva.token = '';
      }
    }
  }

  runApp(InicializaApp(analises, sessaoAtiva));
}

class InicializaApp extends StatelessWidget {
  final List<Analise> analises;
  final Sessao sessao;
  const InicializaApp(this.analises, this.sessao, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(sessao)),
        BlocProvider(create: (context) => AnalisesBloc(sessao))
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: sessao.token.isNotEmpty ? Home(analises) : BemVindoPage(analises),
      ),
    );
  }
}
