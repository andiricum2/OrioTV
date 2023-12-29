import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oriotv/src/utils/constants.dart';
import 'package:oriotv/src/models/content.dart';

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
        '$_baseUrl/3/${convertedMediaType == MediaType.series ? 'tv' : 'movie'}/$tmdbId?api_key=$_apiKey&language=es-ES');

    final response = await http.get(mediaDetailsUrl);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error fetching media details from TMDb');
    }
  }

  String? getImageUrl(String? posterUrl, String? size) {
    if (posterUrl != null && posterUrl.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/$size/$posterUrl';
    }
    return null;
  }

  String? getBackdropUrl(String? backdropUrl, String? size) {
    if (backdropUrl != null && backdropUrl.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/$size/$backdropUrl';
    }
    return null;
  }

  Future<void> updateMediaDetails(List<Media> mediaList) async {
    for (Media media in mediaList) {
      try {
        Map<String, dynamic> tmdbDetails = await getMediaDetails(
          media.tmdbId ?? 0,
          media.type ?? "other",
        );

        media.title = tmdbDetails['title'] ?? tmdbDetails['name'];
        media.description = tmdbDetails['overview'];
        media.posterUrl = getImageUrl(tmdbDetails['poster_path'], "w400");
        media.backdropUrl =
            getBackdropUrl(tmdbDetails['backdrop_path'], "w1280");
        media.popularity = tmdbDetails['popularity'];
        media.releaseDate = tmdbDetails['first_air_date'];
        print("DOma");
      } catch (e) {
        print('Error loading TMDb details: $e');
      }
    }
  }
}
