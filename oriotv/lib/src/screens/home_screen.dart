import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';
import 'package:oriotv/src/widgets/content_card.dart';
import 'package:oriotv/src/widgets/carousel_widget.dart';
import 'package:oriotv/src/services/tmdb_service.dart';
import 'package:oriotv/src/widgets/menu_widget.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const HomeScreen({Key? key, required this.data}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TmdbService tmdbService = TmdbService();
  late List<Media> movies;
  late List<Media> series;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    movies = _parseMediaList(widget.data['movies']);
    series = _parseMediaList(widget.data['series']);
    _initializeMediaLists();
    _pageController = PageController(viewportFraction: 0.8);
  }

  List<Media> _parseMediaList(List<dynamic>? mediaData) =>
      mediaData?.map((e) => Media.fromJson(e)).toList() ?? [];

  Future<void> _initializeMediaLists() async {
    await _loadTmdbDetails(movies);
    await _loadTmdbDetails(series);
  }

  Future<void> _loadTmdbDetails(List<Media> mediaList) async {
    for (Media media in mediaList) {
      try {
        Map<String, dynamic> tmdbDetails = await tmdbService.getMediaDetails(
          media.tmdbId ?? 0,
          media.type ?? "other",
        );

        setState(() {
          media.title = tmdbDetails['title'] ?? tmdbDetails['name'];
          media.description = tmdbDetails['overview'];
          media.posterUrl = tmdbService.getImageUrl(tmdbDetails['poster_path']);
          media.backdropUrl =
              tmdbService.getBackdropUrl(tmdbDetails['backdrop_path']);
        });
      } catch (e) {
        print('Error loading TMDb details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final isHorizontal =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tu aplicación'),
        automaticallyImplyLeading: isPortrait,
      ),
      drawer: isPortrait ? null : MenuWidget(isPortrait: isPortrait),
      bottomNavigationBar:
          isPortrait ? MenuWidget(isPortrait: isPortrait) : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                if (isHorizontal)
                  MenuWidget(
                      isPortrait:
                          isPortrait), // Agrega el menú en pantallas horizontales
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: CarouselCard(
                          pageController: _pageController,
                          movies: movies,
                          series: series,
                        ),
                      ),
                      _buildSection("Películas", movies),
                      _buildSection("Series", series),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
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
            itemBuilder: (context, index) =>
                ContentCard(media: contentList[index]),
          ),
        ),
      ],
    );
  }
}
