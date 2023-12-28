import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';
import 'package:oriotv/src/widgets/content_card.dart';
import 'package:oriotv/src/services/tmdb_service.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const HomeScreen({super.key, required this.data});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Media> movies;
  late List<Media> series;
  final TmdbService tmdbService = TmdbService();

  @override
  void initState() {
    super.initState();
    // Inicializar la lista de películas y series (puedes hacer lo mismo para otras categorías)
    movies = _createMediaList(widget.data['movies']);
    series = _createMediaList(widget.data['series']);

    // Cargar detalles de TMDb para cada película y serie
    _loadTmdbDetails(movies);
    _loadTmdbDetails(series);
  }

  List<Media> _createMediaList(List<dynamic>? mediaData) {
    return (mediaData)?.map((e) => Media.fromJson(e)).toList() ?? [];
  }

  Future<void> _loadTmdbDetails(List<Media> mediaList) async {
    for (Media media in mediaList) {
      try {
        Map<String, dynamic> tmdbDetails = await tmdbService.getMediaDetails(
            media.tmdbId,
            media
                .type); // Asegúrate de modificar getMediaDetails en tu TmdbService para manejar películas y series

        // Actualizar el objeto 'media' con los detalles de TMDb según sea necesario
        setState(() {
          // Ejemplo de actualización del título y descripción
          media.title = tmdbDetails['title'];
          media.description = tmdbDetails['overview'];

          // Obtener la URL de la imagen
          media.posterUrl =
              tmdbService.getImageUrl(tmdbDetails['poster_path']);
        });
      } catch (e) {
        print('Error al cargar detalles de TMDb: $e');
      }
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrioTV'),
      ),
      body: ListView(
        children: [
          _buildSection("Películas", movies),
          _buildSection("Series", series),
          // Puedes agregar más secciones para otras categorías (series, documentales, etc.)
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Media> contentList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: contentList.length,
            itemBuilder: (context, index) {
              return ContentCard(media: contentList[index]);
            },
          ),
        ),
      ],
    );
  }
}
