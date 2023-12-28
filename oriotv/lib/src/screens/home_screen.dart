import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';
import 'package:oriotv/src/widgets/content_card.dart';
import 'package:oriotv/src/services/tmdb_service.dart';
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

    movies = (widget.data['movies'] as List<dynamic>?)
            ?.map((e) => Media.fromJson(e))
            .toList() ??
        [];

    series = (widget.data['series'] as List<dynamic>?)
            ?.map((e) => Media.fromJson(e))
            .toList() ??
        [];

    _initializeMediaLists();
    _pageController = PageController(viewportFraction: 0.8);
  }

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCarousel(),
            _buildSection("Películas", movies),
            _buildSection("Series", series),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: movies.length + series.length,
        itemBuilder: (context, index) {
          final media = index < movies.length
              ? movies[index]
              : series[index - movies.length];
          return _buildCarouselItem(media);
        },
      ),
    );
  }

  Widget _buildCarouselItem(Media media) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage(media.backdropUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              media.title ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
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
            itemBuilder: (context, index) =>
                ContentCard(media: contentList[index]),
          ),
        ),
      ],
    );
  }
}
