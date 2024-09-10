import 'dart:convert';  // Para codificar e decodificar JSON
import 'package:http/http.dart' as http;  // Para fazer solicitações HTTP

class AuthService {
  final String apiUrl = 'http://localhost:8080/auth/login';  // URL do backend

  // Função para fazer login
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Se o servidor retornar um código de sucesso, parse o JSON.
        final data = jsonDecode(response.body);
        // Aqui você pode armazenar o token, fazer navegação, etc.
        print('Login successful: ${data}');
      } else {
        // Se o servidor retornar um código de erro, lance uma exceção.
        print('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Em caso de erro na solicitação, capture e exiba o erro.
      print('Error during login: $e');
    }
  }
}
