import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_search_app/components/ApiUrl.dart';
import 'dart:convert';
import 'package:parking_search_app/models/Vaga.dart';

class VagaDetailScreen extends StatefulWidget {
  final int vagaId;

  const VagaDetailScreen({Key? key, required this.vagaId}) : super(key: key);

  @override
  _VagaDetailScreenState createState() => _VagaDetailScreenState();
}

class _VagaDetailScreenState extends State<VagaDetailScreen> {
  Vaga? vaga;
  Map<String, dynamic>? proprietario;
  late List<String> _imageUrls;
  late PageController _pageController;
  int _currentImageIndex = 0;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _imageUrls = [];
    _pageController = PageController();
    _fetchVagaDetails();
  }

  Future<void> _fetchVagaDetails() async {
    final String vagaUrl = ApiUrl.BuscarVagaPorId(widget.vagaId.toString());
    try {
      final response = await http.get(Uri.parse(vagaUrl));

      if (response.statusCode == 200) {
        final vagaData = json.decode(response.body);
        setState(() {
          vaga = Vaga.fromJson(vagaData);
          _imageUrls = vaga?.imagemUrls?.split(',') ?? [];
          _imageUrls = _imageUrls.map((url) => 'http://localhost:8080' + url).toList();
          _fetchProprietario(); // Chama para buscar o proprietário após obter os detalhes da vaga
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao carregar detalhes da vaga';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer requisição da Vaga: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProprietario() async {
    if (vaga?.proprietarioId == null) {
      setState(() {
        _errorMessage = 'ID do proprietário é nulo';
        _isLoading = false;
      });
      print('ID do proprietário é nulo');
      return;
    }

    final String proprietarioUrl = ApiUrl.proprietarioUrl(vaga!.proprietarioId.toString());
    print('URL do Proprietário: $proprietarioUrl'); // Debug URL
    try {
      final response = await http.get(Uri.parse(proprietarioUrl));
      print('Status Code do Proprietário: ${response.statusCode}'); // Debug Status Code

      if (response.statusCode == 200) {
        final proprietarioData = json.decode(response.body);
        print('Dados do Proprietário: $proprietarioData'); // Debug Dados do Proprietário
        setState(() {
          proprietario = proprietarioData;
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao carregar informações do proprietário';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer requisição do Proprietario: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Vaga'),
        backgroundColor: const Color(0xFF42426F),
      ),
      body: Container(
        color: const Color.fromARGB(255, 19, 20, 43), // Azul marinho
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.white)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 300,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: _imageUrls.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    _imageUrls[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Text('Erro ao carregar imagem', style: TextStyle(color: Colors.white)));
                                    },
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _imageUrls.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentImageIndex == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 50,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 50,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          vaga?.descricao ?? '',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Preço: R\$${vaga?.preco.toStringAsFixed(2) ?? 'Não disponível'}',
                          style: const TextStyle(fontSize: 20, color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Endereço: ${vaga?.rua ?? ''}, ${vaga?.numero ?? ''} - ${vaga?.bairro ?? ''}, ${vaga?.cidade ?? ''}/${vaga?.estado ?? ''}',
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        proprietario == null
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Informações do Proprietário',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 158, 34, 34),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person, color: Color(0xFF42426F), size: 40),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Nome: ${proprietario!['name'] ?? 'Não disponível'}',
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Email: ${proprietario!['email'] ?? 'Não disponível'}',
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Telefone: ${proprietario!['phone'] ?? 'Não disponível'}',
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Quantidade de Vagas: ${proprietario!['vagas']?.length ?? 0}',
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
