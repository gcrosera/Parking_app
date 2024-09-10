import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_search_app/components/ApiUrl.dart';
import 'package:parking_search_app/components/consts.dart';
import 'dart:convert';
import 'package:parking_search_app/screens/login.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<CadastroScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  String? _mensagemErro;
  bool erro = false;
  bool obscureText = true;
  bool _carregando = false;

  Future<void> _register() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    var url = Uri.parse(ApiUrl.registerUrl()); // URL do endpoint de cadastro
    var body = {
      "name": _name.text,
      "email": _email.text,
      "password": _senha.text,
      "phone": _phone.text
    };
    var jsonBody = jsonEncode(body);
    http.Response? response;

    try {
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      // Verificar a resposta da API
      if (response.statusCode == 201) { // Alterado para 201 que é o status de criação bem-sucedida
        // Se o cadastro for bem-sucedido, navegue de volta para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()), 
        );
      } else {
        // Para outros códigos de status, exiba uma mensagem de erro
        setState(() {
          _mensagemErro = 'Erro ao cadastrar. Status code: ${response?.statusCode}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro', style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: azulEuro,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _senha,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextField(
              controller: _phone,
              decoration: InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            _carregando
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: Text('Cadastrar'),
                  ),
            if (erro) ...[
              SizedBox(height: 20),
              Text(
                _mensagemErro ?? 'Erro desconhecido',
                style: TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
