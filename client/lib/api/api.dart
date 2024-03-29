import 'package:client/constants.dart';
import 'package:client/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api{
  static const trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const bingeWorthyUrl = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const newReleasesUrl = 'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';

  static const searchUrl = 'https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&query=';

  Future<List<Movie>> getTrendingMovies() async{
    // Make a network call to the trending movies endpoint
    // Parse the JSON response into a list of Movie objects
    // Return the list of Movie objects
    final response = await http.get(Uri.parse(trendingUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    }else{
      throw Exception('Failed to load movies');
    }
  }

    Future<List<Movie>> getTopRated() async{
    // Make a network call to the trending movies endpoint
    // Parse the JSON response into a list of Movie objects
    // Return the list of Movie objects
    final response = await http.get(Uri.parse(bingeWorthyUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    }else{
      throw Exception('Failed to load movies');
    }
  }

    Future<List<Movie>> getNewReleases() async{
    // Make a network call to the trending movies endpoint
    // Parse the JSON response into a list of Movie objects
    // Return the list of Movie objects
    final response = await http.get(Uri.parse(newReleasesUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    }else{
      throw Exception('Failed to load movies');
    }
  }

Future<List<Movie>> searchMovies(String? query) async {
  final encodedQuery = Uri.encodeQueryComponent(query!);
  final response = await http.get(Uri.parse(searchUrl + encodedQuery));

  if (response.statusCode == 200) {
    final decodeData = json.decode(response.body);
    
    if (decodeData != null && decodeData['results'] != null) {
      final List<Movie> movies = (decodeData['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to decode movies data');
    }
  } else {
    throw Exception('Failed to load movies. Status code: ${response.statusCode}');
  }
}

Future<Movie> searchMovie(String query) async {
  final response = await http.get(Uri.parse(searchUrl + query));

  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);
    
    if (decodedData != null && decodedData['results'] != null) {
      // Assuming you want to get the first movie from the results
      final Map<String, dynamic> movieData = (decodedData['results'] as List).first;

      // Creating a single Movie instance from the first result
      final Movie movie = Movie.fromJson(movieData);

      return movie;
    } else {
      throw Exception('Failed to decode movies data');
    }
  } else {
    throw Exception('Failed to load movies. Status code: ${response.statusCode}');
  }
}
}