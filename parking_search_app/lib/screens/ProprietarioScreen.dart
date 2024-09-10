import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parking_search_app/components/ApiUrl.dart';

class ProprietarioPage extends StatefulWidget {
  final String proprietarioId;

  const ProprietarioPage({Key? key, required this.proprietarioId}) : super(key: key);

  @override
  _ProprietarioPageState createState() => _ProprietarioPageState();
}

class _ProprietarioPageState extends State<ProprietarioPage> {
  Map<String, dynamic>? proprietario;

  @override
  void initState() {
    super.initState();
    _fetchProprietario();
  }

  Future<void> _fetchProprietario() async {
    final String url = ApiUrl.proprietarioUrl(widget.proprietarioId); // Substitua pela URL correta
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        proprietario = json.decode(response.body);
      });
    } else {
      print('Erro ao carregar informações do proprietário');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do Proprietário'),
        backgroundColor: const Color.fromARGB(255, 19, 20, 43), // Azul marinho
      ),
      body: Container(
        color: const Color.fromARGB(255, 3, 23, 43), // Azul marinho
        child: proprietario == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagem e informações do proprietário
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      proprietario!['name'] ?? 'Não disponível',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${proprietario!['email'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Telefone: ${proprietario!['phone'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    // Informações das vagas
                    Text(
                      'Vagas Anunciadas:',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${proprietario!['vagas'].length} Vagas',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Informações das vagas
                    Text(
                      'Minhas Vagas',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150, // Altura do ListView
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: proprietario!['vagas'].length,
                        itemBuilder: (context, index) {
                          final vaga = proprietario!['vagas'][index];
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vaga['descricao'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Preço: R\$${vaga['preco'].toString()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Endereço: ${vaga['numero']}, ${vaga['bairro']}, ${vaga['cidade']}',
                                  style: const TextStyle(fontSize: 14, color: Colors.white54),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
