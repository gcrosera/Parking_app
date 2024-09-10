import 'package:latlong2/latlong.dart';

class Vaga {
  final int id;
  final String descricao;
  final double preco;
  final String cep;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final LatLng localizacao;
  final int proprietarioId;
  final String imagemUrls; // Mudança de List<String> para String

  Vaga({
    required this.id,
    required this.descricao,
    required this.preco,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.localizacao,
    required this.proprietarioId,
    required this.imagemUrls, // Recebe apenas uma URL
  });

  factory Vaga.fromJson(Map<String, dynamic> json) {
    return Vaga(
      id: json['id'],
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      cep: json['cep'],
      rua: json['rua'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      proprietarioId: json['proprietarioId'],
      localizacao: LatLng(0.0, 0.0), 
      imagemUrls: json['imagemUrl'], // Recebe diretamente a string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'preco': preco,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'proprietarioId': proprietarioId,
      'imagemUrl': imagemUrls, // Retorna a string diretamente
    };
  }
}
