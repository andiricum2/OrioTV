import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';
import 'package:oriotv/src/services/tmdb_service.dart';
import 'package:oriotv/src/screens/player_screen.dart';

class DetailScreen extends StatelessWidget {
  final Media media;
  final TmdbService? tmdbService;

  const DetailScreen({Key? key, required this.media, this.tmdbService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              _buildBackdropImage(context),
              _buildMovieInfo(context, orientation),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackdropImage(BuildContext context) {
    final String? backdropUrl =
        tmdbService?.getBackdropUrl(media.backdropUrl, "original") ??
            media.backdropUrl;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: backdropUrl != null
            ? DecorationImage(
                image: NetworkImage(backdropUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: backdropUrl == null
          ? Center(
              child: Text(
                'Sin imagen disponible',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildMovieInfo(BuildContext context, Orientation orientation) {
    final String? posterUrl =
        tmdbService?.getImageUrl(media.posterUrl, "original") ??
            media.posterUrl;

    final double posterWidth =
        orientation == Orientation.portrait ? 120.0 : 200.0;
    final double posterHeight = posterWidth * 1.5;

    return Center(
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: orientation == Orientation.portrait
            ? _buildPortraitLayout(
                context, posterUrl, posterWidth, posterHeight)
            : _buildLandscapeLayout(
                context, posterUrl, posterWidth, posterHeight),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, String? posterUrl,
      double posterWidth, double posterHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPosterImage(context, posterUrl, posterWidth, posterHeight),
        SizedBox(height: 16.0),
        _buildMovieTitle(context),
        SizedBox(height: 8.0),
        _buildMovieInfoText('Género', media.genre),
        _buildMovieInfoText('Fecha de lanzamiento', media.releaseDate),
        _buildMovieInfoText('Popularidad', media.popularity.toString()),
        SizedBox(height: 16.0),
        _buildSectionTitle('Descripción:'),
        SizedBox(height: 8.0),
        _buildMovieInfoText(
            'Descripción', media.description ?? 'Sin descripción disponible'),
        SizedBox(height: 16.0),
        _buildPlayButton(context, media),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, String? posterUrl,
      double posterWidth, double posterHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPosterImage(context, posterUrl, posterWidth, posterHeight),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieTitle(context),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.white, size: 16.0),
                  SizedBox(width: 8.0),
                  _buildMovieInfoText('Género', media.genre),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.white, size: 16.0),
                  SizedBox(width: 8.0),
                  _buildMovieInfoText(
                      'Fecha de lanzamiento', media.releaseDate),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.white, size: 16.0),
                  SizedBox(width: 8.0),
                  _buildMovieInfoText(
                      'Popularidad', media.popularity.toString()),
                ],
              ),
              SizedBox(height: 16.0),
              _buildSectionTitle('Descripción:'),
              SizedBox(height: 8.0),
              _buildMovieInfoText('Descripción',
                  media.description ?? 'Sin descripción disponible'),
              SizedBox(height: 16.0),
              _buildPlayButton(context, media),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPosterImage(
      BuildContext context, String? posterUrl, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: posterUrl != null
              ? DecorationImage(
                  image: NetworkImage(posterUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: posterUrl == null
            ? Center(
                child: Text(
                  'Sin imagen disponible',
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildMovieTitle(BuildContext context) {
    return Text(
      media.title ?? 'Título Desconocido',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMovieInfoText(String label, String? value) {
    return Text(
      '$label: ${value ?? 'Desconocido'}',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, Media media) {
    return ElevatedButton.icon(
      onPressed: () async {
        // Navigate to the WebView screen and pass the Media object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyWebViewScreen(media: media),
          ),
        );
      },
      icon: Icon(Icons.play_arrow, size: 24.0),
      label: Text('Reproducir'),
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
