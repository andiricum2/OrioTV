import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';
import 'package:oriotv/src/widgets/content_card.dart';
import 'package:oriotv/src/widgets/featured_card.dart';
import 'package:oriotv/src/widgets/carousel_widget.dart';
import 'package:oriotv/src/services/tmdb_service.dart';
import 'package:oriotv/src/widgets/menu_widget.dart';
import 'package:oriotv/src/screens/detail_screen.dart';
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
          media.posterUrl =
              tmdbService.getImageUrl(tmdbDetails['poster_path'], "w400");
          media.backdropUrl =
              tmdbService.getBackdropUrl(tmdbDetails['backdrop_path'], "w1280");
          media.popularity = tmdbDetails['popularity'];
          media.releaseDate = tmdbDetails['first_air_date'];
        });
      } catch (e) {
        print('Error loading TMDb details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.tv), // Añade un icono de televisión
            SizedBox(width: 8.0), // Ajusta el espaciado según sea necesario
            Text('OrioTV'),
          ],
        ),
        automaticallyImplyLeading: !isHorizontal,
      ),
      drawer: isHorizontal ? MenuWidget() : null,
      bottomNavigationBar: isHorizontal ? null : MenuWidget(),
      body: SafeArea(
        child: isHorizontal ? _buildHorizontalLayout() : _buildVerticalLayout(),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            MenuWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FeaturedCard(
                      pageController: _pageController,
                      featuredContent: movies + series,
                      onTap: (media) => _openDetailScreen(media),
                    ),
                    _buildSection("Películas", movies),
                    _buildSection("Series", series),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerticalLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselCard(
            pageController: _pageController,
            carouselContent: movies + series,
            onTap: (media) => _openDetailScreen(media),
          ),
          _buildSection("Películas", movies),
          _buildSection("Series", series),
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
              return ContentCard(
                media: contentList[index],
                onTap: (media) => _openDetailScreen(media),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openDetailScreen(Media media) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailScreen(media: media, tmdbService: tmdbService),
      ),
    );
  }
}
