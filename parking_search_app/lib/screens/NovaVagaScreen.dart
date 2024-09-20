import 'dart:convert';
import 'dart:io'; // Para manipular arquivos em dispositivos móveis
import 'package:flutter/foundation.dart'; // Para verificar se está na web
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Para selecionar imagens
import 'package:http_parser/http_parser.dart';
import 'package:parking_search_app/components/ApiUrl.dart'; // Para converter para base64

class NovaVagaScreen extends StatefulWidget {
  final String userId;
  final String token;

  const NovaVagaScreen({required this.userId, required this.token, Key? key}) : super(key: key);

  @override
  _NovaVagaScreenState createState() => _NovaVagaScreenState();
}

class _NovaVagaScreenState extends State<NovaVagaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  String _precoTipo = 'hora'; // padrão: preço por hora
  List<XFile>? _imagens; // Lista de imagens capturadas

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.length <= 4) {
        setState(() {
          _imagens = pickedFiles;
        });
      } else if (pickedFiles != null && pickedFiles.length > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Você só pode selecionar até 4 imagens.')),
        );
      }
    } catch (e) {
      print('Erro ao selecionar imagens: $e');
    }
  }

  Future<void> _anunciarVaga() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse(ApiUrl.novaVaga(widget.userId));

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer ${widget.token}';

       // Cria um JSON com os dados da vaga
    var vagaJson = jsonEncode({
      'descricao': _descricaoController.text,
      'preco': _precoController.text,
      'cep': _cepController.text,
      'rua': _logradouroController.text,
      'numero': _numeroController.text,
      'bairro': _bairroController.text,
      'cidade': _cidadeController.text,
      'estado': _estadoController.text,
    });


      // Adiciona o JSON da vaga como parte do request
      request.fields['vaga'] = vagaJson;

      // Adiciona as imagens
      if (_imagens != null) {
        for (var image in _imagens!) {
          if (kIsWeb) {
            request.files.add(http.MultipartFile.fromBytes(
              'imagens',
              await image.readAsBytes(),
              filename: image.name,
              contentType: MediaType('image', 'jpeg'),
            ));
          } else {
            request.files.add(await http.MultipartFile.fromPath(
              'imagens',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ));
          }
        }
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          _showSuccessDialog();
        } else {
          print('Erro ao criar vaga: ${response.statusCode}');
          final responseBody = await response.stream.bytesToString();
          print('Resposta do servidor: $responseBody');
        }
      } catch (e) {
        print('Erro de conexão: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anunciar Nova Vaga'),
        backgroundColor: const Color(0xFF42426F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              // Campo de preço
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  return null;
                },
              ),
              // Tipo de preço (hora, dia, mês)
              DropdownButtonFormField<String>(
                value: _precoTipo,
                decoration: const InputDecoration(labelText: 'Tipo de Preço'),
                items: ['hora', 'dia', 'mes']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _precoTipo = value!;
                  });
                },
              ),
              // Campo de CEP
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 8) {
                    _buscarEnderecoPorCep();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CEP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _logradouroController,
                decoration: const InputDecoration(labelText: 'Rua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a rua';
                  }
                  return null;
                },
              ),

              // Campo de número
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número';
                  }
                  return null;
                },
              ),
              // Campo de bairro
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o bairro';
                  }
                  return null;
                },
              ),
              // Campo de cidade
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cidade';
                  }
                  return null;
                },
              ),
              // Campo de estado
              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o estado';
                  }
                  return null;
                },
              ),
              // Botão para selecionar imagens
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Selecionar Imagens (máximo 4)'),
              ),
              // Exibir preview das imagens selecionadas
              if (_imagens != null)
                Wrap(
                  spacing: 10,
                  children: _imagens!.map((image) {
                    return kIsWeb
                        ? Image.network(
                            image.path,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(image.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              // Botão de "Anunciar Vaga"
              ElevatedButton(
                onPressed: _anunciarVaga,
                child: const Text('Anunciar Vaga'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buscarEnderecoPorCep() async {
    final cep = _cepController.text;
    if (cep.isEmpty) return;

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('erro')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CEP não encontrado')),
          );
        } else {
          _logradouroController.text = data['logradouro'] ?? '';
          _bairroController.text = data['bairro'] ?? '';
          _cidadeController.text = data['localidade'] ?? '';
          _estadoController.text = data['uf'] ?? '';
        }
      }
    } catch (e) {
      print('Erro ao buscar endereço: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vaga Anunciada'),
          content: const Text('Sua vaga foi anunciada com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
