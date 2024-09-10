class ApiUrl {
  static const String baseUrl = 'https://wise-frogs-find.loca.lt'; // Base URL da sua API

  static String loginUrl() => '$baseUrl/users/login';
  static String registerUrl() => '$baseUrl/users/register';
  static String proprietarioUrl(String id) => '$baseUrl/proprietarios/$id';
  static String vagasByProprietarioUrl(String id) => '$baseUrl/proprietarios/$id/BucarVagas';

  static String novaVaga(String id) => '$baseUrl/vagas/novaVaga/$id';
  
  static String BuscarVagaPorId(String id) => '$baseUrl/vagas/BuscarVagaPorId/$id';

  static String mostrarTodasAsVagas(String id) => '$baseUrl/vagas/buscarTodas';
  // Adicione outros endpoints conforme necessário
}
