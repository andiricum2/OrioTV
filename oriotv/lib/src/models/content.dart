class Media {
  int? tmdbId;
  String? title;
  String? description;
  String? posterUrl;
  String? backdropUrl; // Add this line
  String? type;
  List<Season>? seasons;
  List<Episode>? episodes;
  String? releaseDate;
  double? popularity;
  String? genre;
  String? url;

  Media({
    this.tmdbId,
    this.title,
    this.description,
    this.posterUrl,
    this.backdropUrl, // Add this line
    this.type,
    this.seasons,
    this.episodes,
    this.releaseDate,
    this.popularity,
    this.genre,
    this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      tmdbId: json['tmdbId'],
      title: json['title'],
      description: json['description'],
      posterUrl: json['poster_url'],
      backdropUrl: json['backdrop_url'], // Add this line
      type: json['type'],
      releaseDate: json['releaseDate'],
      popularity: json['popularity'],
      genre: json['genre'],
      url: json['url'],
      seasons: json['seasons'] != null
          ? List<Season>.from(
              json['seasons'].map((season) => Season.fromJson(season)))
          : null,
      episodes: json['episodes'] != null
          ? List<Episode>.from(
              json['episodes'].map((episode) => Episode.fromJson(episode)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tmdbId': tmdbId,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl, // Add this line
      'type': type,
      'releaseDate': releaseDate,
      'popularity': popularity,
      'seasons': seasons?.map((season) => season.toJson()).toList(),
      'episodes': episodes?.map((episode) => episode.toJson()).toList(),
    };
  }
}

class Season {
  final int seasonNumber;
  final List<Episode> episodes;

  Season({
    required this.seasonNumber,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'],
      episodes: List<Episode>.from(
          json['episodes'].map((episode) => Episode.fromJson(episode))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'episodes': episodes.map((episode) => episode.toJson()).toList(),
    };
  }
}

class Episode {
  final int episodeNumber;
  final String title;
  final String description;

  Episode({
    required this.episodeNumber,
    required this.title,
    required this.description,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episodeNumber'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'episodeNumber': episodeNumber,
      'title': title,
      'description': description,
    };
  }
}
