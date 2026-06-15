class MovieDetailsResponse {
  final String? status;
  final String? statusMessage;
  final MovieData? data;

  MovieDetailsResponse({
    this.status,
    this.statusMessage,
    this.data,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailsResponse(
      status: json['status'],
      statusMessage: json['status_message'],
      data: json['data'] != null ? MovieData.fromJson(json['data']) : null,
    );
  }
}

class MovieData {
  final Movie? movie;

  MovieData({this.movie});

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      movie: json['movie'] != null ? Movie.fromJson(json['movie']) : null,
    );
  }
}

class Movie {
  final int? id;
  final String? title;
  final int? year;
  final double? rating;
  final int? runtime;

  final String? largeCoverImage;
  final String? backgroundImage;

  final List<String> screenshots;
  final List<Cast> cast;

  Movie({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.runtime,
    this.largeCoverImage,
    this.backgroundImage,
    required this.screenshots,
    required this.cast,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Screenshots safe parsing
    final shots = [
      json['large_screenshot_image1'],
      json['large_screenshot_image2'],
      json['large_screenshot_image3'],
    ]
        .where((e) => e != null && e.toString().isNotEmpty)
        .map((e) => e.toString())
        .toList();

    // Cast safe parsing
    final castList = (json['cast'] as List<dynamic>?)
        ?.map((e) => Cast.fromJson(e))
        .toList() ??
        [];

    return Movie(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      rating: (json['rating'] as num?)?.toDouble(),
      runtime: json['runtime'],
      largeCoverImage: json['large_cover_image'],
      backgroundImage: json['background_image'],
      screenshots: shots,
      cast: castList,
    );
  }
}

class Cast {
  final String? name;
  final String? characterName;
  final String? image;

  Cast({
    this.name,
    this.characterName,
    this.image,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
      characterName: json['character_name'],
      image: json['url_small_image'],
    );
  }
}