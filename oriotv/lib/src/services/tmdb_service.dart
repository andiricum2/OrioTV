import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oriotv/src/utils/constants.dart';

class TmdbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = Constants.tmdbApiKey;

  Future<Map<String, dynamic>> getMediaDetails(
      int tmdbId, String mediaType) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$mediaType/$tmdbId?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener detalles del medio desde TMDb');
    }
  }

  getImageUrl(String? posterPath) {
    if (posterPath != null && posterPath.isNotEmpty) {
      // Puedes construir la URL completa de la imagen utilizando la base de la URL de TMDb
      return 'https://image.tmdb.org/t/p/w200/$posterPath';
    }
    return null;
  }

  Future<Map<String, dynamic>> getMovieDetails(int tmdbId) async {
    return getMediaDetails(tmdbId, 'movie');
  }

  Future<Map<String, dynamic>> getTVDetails(int tmdbId) async {
    print(tmdbId);
    return getMediaDetails(tmdbId, 'tv');
  }
}
