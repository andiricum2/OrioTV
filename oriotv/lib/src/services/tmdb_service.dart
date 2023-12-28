import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oriotv/src/utils/constants.dart';

enum MediaType { movie, series }

class TmdbService {
  static const String _baseUrl = 'https://api.themoviedb.org';
  static const String _apiKey = Constants.tmdbApiKey;

  static MediaType stringToMediaType(String type) {
    return type.toLowerCase() == 'series' ? MediaType.series : MediaType.movie;
  }

  Future<Map<String, dynamic>> getMediaDetails(
      int tmdbId, String mediaType) async {
    final convertedMediaType = stringToMediaType(mediaType);

    final mediaDetailsUrl = Uri.parse(
        '$_baseUrl/3/${convertedMediaType == MediaType.series ? 'tv' : 'movie'}/$tmdbId?api_key=$_apiKey');

    final response = await http.get(mediaDetailsUrl);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error fetching media details from TMDb');
    }
  }

  String? getImageUrl(String? posterUrl) {
    if (posterUrl != null && posterUrl.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w400/$posterUrl';
    }
    return null;
  }

  String? getBackdropUrl(String? backdropUrl) {
    if (backdropUrl != null && backdropUrl.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w1280/$backdropUrl';
    }
    return null;
  }
}
