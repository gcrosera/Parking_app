import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:parking_search_app/components/ApiUrl.dart';
import 'package:parking_search_app/components/campo.dart';
import 'package:parking_search_app/components/consts.dart';
import 'package:parking_search_app/screens/CadastroScreen.dart';
import 'package:parking_search_app/screens/home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  String? _mensagemErro;
  bool erro = false;
  bool obscureText = true;
  bool _carregando = false;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    var url = Uri.parse(ApiUrl.loginUrl());
    var body = {"email": _email.text, "senha": _senha.text};
    var jsonBody = jsonEncode(body);
    http.Response? response;

    try {
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      // Verificar a resposta da API
        if (response.statusCode == 200) {
            var responseData = jsonDecode(response.body);
            String token = responseData['token'];
            int userId = responseData['userId'];

            // Armazena o token se necessário e navega para a HomeScreen com o userId
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(userId: userId.toString(), token: token)),
            );
        }else if (response.statusCode == 401) {
        // Se a resposta for 401, exiba uma mensagem de erro
        setState(() {
          _mensagemErro = 'Email ou senha inválidos';
          _carregando = false;
          erro = true;
        });
      } else {
        // Para outros códigos de status, exiba uma mensagem de erro genérica
        setState(() {
          _mensagemErro = 'Erro ao fazer login. Status code: ${response?.statusCode}';
          _carregando = false;
          erro = true;
        });
      }
    } catch (e) {
      // Captura e exibe erros de requisição
      setState(() {
        _mensagemErro = 'Erro: $e';
        _carregando = false;
        erro = true;
      });
    }
  }

  void mostrarSenha() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: azulEuro),
                  SizedBox(height: 5),
                  Text("Validando dados..."),
                ],
              ),
            )
          : Column(
              children: [
               Container(
  width: double.infinity,
  height: 150,
  decoration: const BoxDecoration(
    color: azulEuro,
    borderRadius: BorderRadius.only(
      bottomLeft: medidaRaio,
      bottomRight: medidaRaio,
    ),
  ),
  child: Center(  // Centraliza o conteúdo do Container
    child: Text(
    'Parking App',
    style: TextStyle(
      fontFamily: 'Cursive', // Definindo uma caligrafia mais bonita
      color: Colors.white,
      fontSize: 40,
      shadows: [
        Shadow(
          offset: Offset(1.5, 1.5),
          color: Colors.black,
        ),
      ],
    ),
  ),
  ),
),

                const SizedBox(height: 60.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
                      child: campoForm(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        label: 'E-mail',
                        erro: erro,
                        isSenha: false,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
                      child: campoForm(
                        controller: _senha,
                        obscureText: obscureText,
                        label: 'Senha',
                        erro: erro,
                        mostrarSenha: mostrarSenha,
                        isSenha: true,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _login,
                        style: const ButtonStyle(
                          backgroundColor: botaoAzul,
                          shape: radiusBorda,
                        ),
                        child: const Text(
                          "ACESSAR",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    if (_mensagemErro != null)
                      Text(
                        _mensagemErro!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  
                  SizedBox(height: 20), // Espaço entre o botão e o link

    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CadastroScreen()),
        );
      },
      child: Text(
        'Fazer cadastro',
        style: TextStyle(
          color: Colors.blueGrey,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
                  
                  ],
                ),
              ],
            ),
    );
  }
}
