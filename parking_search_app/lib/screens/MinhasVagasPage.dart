import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parking_search_app/components/ApiUrl.dart';
import 'package:parking_search_app/screens/NovaVagaScreen.dart';
import 'package:parking_search_app/screens/VagaDetailScreen.dart';

class MinhasVagasScreen extends StatefulWidget {
  final String userId;
  final String token;

  const MinhasVagasScreen({required this.userId, required this.token, Key? key}) : super(key: key);

  @override
  _MinhasVagasScreenState createState() => _MinhasVagasScreenState();
}

class _MinhasVagasScreenState extends State<MinhasVagasScreen> {
  List<dynamic> vagas = [];

  @override
  void initState() {
    super.initState();
    _fetchVagas();
  }

  Future<void> _fetchVagas() async {
    var url = Uri.parse(ApiUrl.vagasByProprietarioUrl(widget.userId));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          vagas = json.decode(utf8.decode(response.bodyBytes));
        });
      } else {
        print('Erro ao carregar vagas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de conexão: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Vagas'),
        backgroundColor: const Color(0xFF42426F),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Minhas Vagas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vagas.length,
              itemBuilder: (context, index) {
                final vaga = vagas[index];
                final imagemUrl = vaga['imagemUrl'] != null && vaga['imagemUrl'] != ''
                    ? 'http://localhost:8080' + vaga['imagemUrl']
                    : '';

                return GestureDetector(
                  onTap: () {
                    _showVagaDetails(vaga);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          imagemUrl.isNotEmpty
                              ? Image.network(
                                  imagemUrl,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Erro ao carregar imagem: $error');
                                    return Center(child: Text('Erro ao carregar imagem'));
                                  },
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: const Center(child: Text('Sem Imagem')),
                                ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vaga['descricao'] ?? 'Descrição não disponível',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Preço: R\$${vaga['preco'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16, color: Colors.green),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Endereço: ${vaga['rua']}, ${vaga['numero']} - ${vaga['bairro']}, ${vaga['cidade']}/${vaga['estado']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovaVagaScreen(userId: widget.userId, token: widget.token),
                  ),
                );
              },
              child: const Text('Anunciar Nova Vaga'),
            ),
          ),
        ],
      ),
    );
  }

  void _showVagaDetails(dynamic vaga) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VagaDetailScreen(
          vagaId: vaga['id'], // Passar o ID da vaga
        ),
      ),
    );
  }
}
