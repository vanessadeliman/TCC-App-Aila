import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/apresentacao.dart';
import 'package:aila/telas/componentes/toggle.dart';
import 'package:aila/telas/telas_internas/home.dart';
import 'package:aila/telas/inicializacao/bloc/login_bloc.dart';
import 'package:aila/telas/inicializacao/bloc/state_events_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask/mask/mask.dart';

class CadastroPage extends StatefulWidget {
  final List<Analise> analises;
  const CadastroPage(this.analises, {super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final TextEditingController cargo = TextEditingController();
  final TextEditingController instituicao = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController confirmaSenha = TextEditingController();
  bool mostrarSenha = false;
  bool mostrarSenhaConfirma = false;
  bool lembrar = false;

  final GlobalKey<FormState> form = GlobalKey<FormState>();

  String? validacao(String? valor) {
    if (valor != null && valor.isEmpty) {
      return 'Informe sua senha!';
    }
    if (senha.text != confirmaSenha.text) {
      return 'As senhas devem ser iguais';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return BemVindoPage(widget.analises);
              }));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SucessoState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return Home(widget.analises);
            }));
          }
          if (state is ErroState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.erro)));
          }
        },
        builder: (context, state) {
          return Form(
            key: form,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Text(
                      'Criar nova conta',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TextFormField(
                  enabled: state is! CarregandoState,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Mask.validations
                      .generic(value, error: 'Informe o seu nome'),
                  controller: nome,
                  decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Nome',
                      hintText: 'Digite seu nome'),
                ),
                TextFormField(
                  enabled: state is! CarregandoState,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Mask.validations
                      .generic(value, error: 'Informe o seu nome'),
                  controller: instituicao,
                  decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Instituição',
                      hintText: 'Digite o nome da sua instituição'),
                ),
                TextFormField(
                  enabled: state is! CarregandoState,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Mask.validations
                      .generic(value, error: 'Informe o seu nome'),
                  controller: cargo,
                  decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Cargo',
                      hintText: 'Estudante, Funcionario...'),
                ),
                TextFormField(
                  enabled: state is! CarregandoState,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Mask.validations.email(value),
                  controller: email,
                  decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'E-mail',
                      hintText: 'exemplo@exemplo.com'),
                ),
                TextFormField(
                  enabled: state is! CarregandoState,
                  validator: validacao,
                  controller: senha,
                  decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',
                      alignLabelWithHint: true,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              mostrarSenha = !mostrarSenha;
                            });
                          },
                          icon: Icon(mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility))),
                  obscureText: !mostrarSenha,
                ),
                TextFormField(
                  enabled: state is! CarregandoState,
                  validator: validacao,
                  controller: confirmaSenha,
                  decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      hintText: 'Digite novamente sua senha',
                      alignLabelWithHint: true,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              mostrarSenhaConfirma = !mostrarSenhaConfirma;
                            });
                          },
                          icon: Icon(mostrarSenhaConfirma
                              ? Icons.visibility_off
                              : Icons.visibility))),
                  obscureText: !mostrarSenhaConfirma,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Lembrar-se'),
                    const Spacer(),
                    Toggle((ativo) {
                      lembrar = ativo;
                    }),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                        child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: state is CarregandoState
                                ? null
                                : () {
                                    if (form.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                          CadastrarEvent(
                                              email: email.text,
                                              senha: senha.text,
                                              cargo: cargo.text,
                                              instituicao: instituicao.text,
                                              nome: nome.text,
                                              lembrar: lembrar));
                                    }
                                  },
                            child: const Text(
                              'Cadastrar-se',
                              style: TextStyle(height: 5),
                            ))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
