import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oriotv/src/utils/constants.dart';
import 'package:oriotv/src/services/tmdb_service.dart';

final TmdbService tmdbService = TmdbService();

Future<Map<String, dynamic>> loadData() async {
  try {
    final response = await http.get(Uri.parse(Constants.jsonUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Error al cargar datos desde la URL');
    }
  } catch (e) {
    print('Error al cargar datos: $e');
    return {};
  }
}
