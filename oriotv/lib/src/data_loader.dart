import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oriotv/src/utils/constants.dart';
import 'package:oriotv/src/services/tmdb_service.dart'; // Asegúrate de importar el servicio TmdbService

final TmdbService tmdbService = TmdbService();

Future<Map<String, dynamic>> loadData() async {
  try {
    final response = await http.get(Uri.parse(Constants.jsonUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Sobrescribir los datos locales con los datos de TMDb
      await loadTmdbData(jsonData);

      return jsonData;
    } else {
      throw Exception('Error al cargar datos desde la URL');
    }
  } catch (e) {
    print('Error al cargar datos: $e');
    // Devuelve un valor predeterminado en caso de error
    return {};
  }
}

Future<Map<String, dynamic>> loadTmdbData(Map<String, dynamic> jsonData) async {
  try {
    // Lógica para hacer la llamada a la API de TMDb para obtener detalles de una película (ajusta según tus necesidades)
    final movieDetails = await tmdbService.getMovieDetails(
        550); // 550 es un ejemplo de tmdbId de una película (ajusta según tus necesidades)

    // Lógica para hacer la llamada a la API de TMDb para obtener detalles de una serie de televisión (ajusta según tus necesidades)
    final tvDetails = await tmdbService.getTVDetails(
        123); // 123 es un ejemplo de tmdbId de una serie de televisión (ajusta según tus necesidades)

    // Puedes combinar los detalles de películas y series según tu lógica específica
    Map<String, dynamic> tmdbData = {
      'movieDetails': movieDetails,
      'tvDetails': tvDetails,
    };

    print(tmdbData);

    return tmdbData;
  } catch (e) {
    throw Exception('Error al cargar datos de TMDb: $e');
  }
}
