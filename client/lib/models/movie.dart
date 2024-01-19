class Movie{
  String title;
  String backDropPath;
  String originalTitle;
  String overView;
  String posterPath;
  String releaseDate;
  double voteAverage;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overView,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(
      title: json['title'] ?? json['Title'],
      backDropPath: json['backdrop_path'],
      originalTitle: json['original_title'],
      overView: json['overview'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average']as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'backdrop_path': backDropPath,
      'original_title': originalTitle,
      'overview': overView,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
    };
  }
}

