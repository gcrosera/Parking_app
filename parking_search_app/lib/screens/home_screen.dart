import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:parking_search_app/components/ApiUrl.dart';
import 'package:parking_search_app/models/Vaga.dart';
import 'package:parking_search_app/screens/MinhasVagasPage.dart';
import 'package:parking_search_app/screens/ProprietarioScreen.dart';
import 'package:parking_search_app/screens/VagaDetailScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:universal_platform/universal_platform.dart';

class HomeScreen extends StatefulWidget {

  final String userId;
  final String token;

  HomeScreen({super.key, required this.userId,required this.token} );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  final MapController _mapController = MapController();
  TextEditingController _searchController = TextEditingController();
  List<Vaga> _vagas = [];
  
  @override
void initState() {
  super.initState();
  _loadVagas();
  _getCurrentLocation(); // Chama diretamente, sem argumentos
}


  Future<void> _loadVagas() async {
    try {
      List<Vaga> vagas = await _fetchVagas();
      setState(() {
        _vagas = vagas;
      });
    } catch (e) {
      print('Erro ao carregar vagas: $e');
    }
  }
Future<void> _getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    setState(() {
      _currentPosition = position;
      _updateMapLocation(position); // Atualiza o mapa com a nova localização
    });
  } catch (e) {
    print('Error occurred while fetching location: $e');
  }
}


void _updateMapLocation(Position position) {
  _mapController.move(LatLng(position.latitude, position.longitude), 14.0);
}

  Future<void> _searchLocation(String query) async {
    final String url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final double lat = double.parse(data[0]['lat']);
        final double lon = double.parse(data[0]['lon']);
        _mapController.move(LatLng(lat, lon), 14.0);
      } else {
        print('Endereço não encontrado');
      }
    } else {
      print('Erro ao buscar localização: ${response.body}');
    }
  }

  Future<LatLng> _geocodeAddress(String rua, String numero, String bairro, String cidade, String estado) async {
  // Construa o endereço de forma adequada
  final addressParts = <String>[];
  if (rua.isNotEmpty) addressParts.add(rua);
  if (numero.isNotEmpty) addressParts.add(numero);
  if (bairro.isNotEmpty) addressParts.add(bairro);
  if (cidade.isNotEmpty) addressParts.add(cidade);
  if (estado.isNotEmpty) addressParts.add(estado);

  // Junte os componentes usando + e faça a codificação URL
  final address = addressParts.join('+');
  String finalAddress = address.replaceAll(' ', '+');
  // Codifique adequadamente os caracteres especiais para URL
final encodedAddress = Uri.encodeComponent(finalAddress);
  final url = 'https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1';

  print('URL de Geocodificação: $url');
  
  final response = await http.get(Uri.parse(url));
  print('Status Code: ${response.statusCode}');
  print('Resposta da API: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      return LatLng(lat, lon);
    } else {
      throw Exception('Endereço não encontrado');
    }
  } else {
    throw Exception('Erro ao geocodificar o endereço: ${response.body}');
  }
}



 Future<List<Vaga>> _fetchVagas() async {
  final response = await http.get(
    Uri.parse(ApiUrl.mostrarTodasAsVagas(widget.userId)),
    headers: {
      'Authorization': 'Bearer ${widget.token}',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> vagasJson = json.decode(utf8.decode(response.bodyBytes));
    List<Future<Vaga>> vagasFutures = [];

    for (var vagaJson in vagasJson) {
      var vagaFuture = _geocodeAddress(
        vagaJson['rua'] ?? '',
        vagaJson['numero'] ?? '',
        vagaJson['bairro'] ?? '',
        vagaJson['cidade'] ?? '',
        vagaJson['estado'] ?? ''
      ).then((localizacao) {
        var vaga = Vaga(
          id: vagaJson['id'] ?? 0,
          descricao: vagaJson['descricao'] ?? '',
          preco: (vagaJson['preco']?.toDouble() ?? 0.0),
          proprietarioId: vagaJson['proprietarioId'] ?? 0,
          cep: vagaJson['cep'] ?? '',
          rua: vagaJson['rua'] ?? '',
          numero: vagaJson['numero'] ?? '',
          bairro: vagaJson['bairro'] ?? '',
          cidade: vagaJson['cidade'] ?? '',
          estado: vagaJson['estado'] ?? '',
          localizacao: localizacao ?? LatLng(0.0, 0.0),
          imagemUrls: vagaJson['imagemUrl'] ?? '', // Lista de URLs de imagens
        );
        
        // Verifique o valor de imagemUrls depois da atribuição
        print('imagemUrl após atribuição: ${vaga.imagemUrls}');

        return vaga;
      }).catchError((error) {
        print('Erro ao geocodificar endereço: $error');
        return Vaga(
          id: vagaJson['id'] ?? 0,
          descricao: vagaJson['descricao'] ?? '',
          preco: (vagaJson['preco']?.toDouble() ?? 0.0),
          proprietarioId: vagaJson['proprietarioId'] ?? 0,
          cep: vagaJson['cep'] ?? '',
          rua: vagaJson['rua'] ?? '',
          numero: vagaJson['numero'] ?? '',
          bairro: vagaJson['bairro'] ?? '',
          cidade: vagaJson['cidade'] ?? '',
          estado: vagaJson['estado'] ?? '',
          localizacao: LatLng(0.0, 0.0), // Valor padrão em caso de erro
          imagemUrls: vagaJson['imagemUrl'] ?? '', // Inclua o campo imagemUrl
        );
      });

      vagasFutures.add(vagaFuture);
    }

    List<Vaga> vagas = await Future.wait(vagasFutures);
    return vagas;
  } else {
    throw Exception('Falha ao carregar vagas: ${response.statusCode}');
  }
}



  List<Marker> _buildMarkers() {
    if (_currentPosition == null) return [];

    return [
      // Marker for current location
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        child: GestureDetector(
          onTap: () {
            _showMyLocationModal(context);
          },
          child: Container(
            child: Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 40,
            ),
          ),
        ),
      ),
      // Markers for parking spots
      ..._vagas.map((vaga) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: vaga.localizacao,
          child: GestureDetector(
            onTap: () => showVagaModal(context, vaga),
            child: Container(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        );
      }).toList(),
    ];
  }


void showVagaModal(BuildContext context, Vaga vaga) {
  print('showVagaModal chamado'); // Verificação inicial

  // Verifique se a URL da imagem não está vazia
  final imagemUrl = vaga.imagemUrls.isNotEmpty ? 'http://localhost:8080' + vaga.imagemUrls : '';
  print(imagemUrl);

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Borda arredondada no topo
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height * 0.5, // Ajuste a altura do modal conforme necessário
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem estática
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Borda arredondada da imagem
                child: AspectRatio(
                  aspectRatio: 1 / 1, // Imagem quadrada
                  child: imagemUrl.isNotEmpty
                      ? Image.network(
                          imagemUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print('Erro ao carregar imagem: $error'); // Mensagem de erro
                            return Center(child: Text('Erro ao carregar imagem: $error'));
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Center(child: Text('Sem Imagem')),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16), // Espaçamento entre a imagem e as informações
            // Informações da Vaga
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vaga.descricao,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 2, // Limita o número de linhas para evitar overflow
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preço: R\$ ${vaga.preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CEP: ${vaga.cep}',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Endereço: ${vaga.rua}, ${vaga.numero} - ${vaga.bairro}, ${vaga.cidade} - ${vaga.estado}',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VagaDetailScreen(vagaId: vaga.id),
                        ),
                      );
                    },
                    child: Text('Ver Detalhes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xFF42426F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}













  void _showMyLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListTile(
          title: Text('Sua localização'),
          subtitle: Text(
              'Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}'),
        );
      },
    );
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: Text(
    'Parking App    User id: ${widget.userId}',
    style: TextStyle(
      fontFamily: 'Cursive', // Definindo uma caligrafia mais bonita
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(1.5, 1.5),
          color: Colors.black,
        ),
      ],
    ),
  ),
  backgroundColor: Color(0xFF42426F),
  actions: [
    Padding(
  padding: const EdgeInsets.only(right: 16.0),
  child: IconButton(
  icon: Icon(Icons.person, color: Colors.white),
  onPressed: () async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0), // Posição do menu
      items: [
        PopupMenuItem<String>(
          value: 'Minha Conta',
          child: Row(
            children: [
              Icon(Icons.account_circle),
              SizedBox(width: 8),
              Text('Minha Conta'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Minhas Vagas',
          child: Row(
            children: [
              Icon(Icons.local_parking),
              SizedBox(width: 8),
              Text('Minhas Vagas'),
            ],
          ),
        ),
      ],
    );

    if (result != null) {
      switch (result) {
        case 'Minha Conta':
          // Navegar para a página de Minha Conta
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProprietarioPage(proprietarioId: widget.userId),
            ),
          );
          break;
        case 'Minhas Vagas':
          // Navegar para a página de Minhas Vagas
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MinhasVagasScreen(userId: widget.userId, token: widget.token),
            ),
          );
          break;
      }
    }
  },
),

),

  ],
),


    body: Stack(
  children: [
    if (_currentPosition != null) // Verifica se _currentPosition foi inicializada
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _buildMarkers(),
          ),
        ],
      )
    else
      Center(
        child: CircularProgressIndicator(), // Exibe um indicador de carregamento enquanto a posição não é obtida
      ),
    Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Pesquisar local...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchLocation(_searchController.text);
              },
            ),
          ),
        ),
      ),
    ),
    Positioned(
      bottom: 20,
      right: 20,
      child: IconButton(
    onPressed: () {
      // Para plataformas web, passa o 'html.window', senão, passa null
      _getCurrentLocation();
    },
    icon: Icon(Icons.my_location),
    color: Colors.blue,
    iconSize: 40,
  ),
    ),
  ],
),
  );
}

}
