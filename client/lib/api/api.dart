import 'package:client/constants.dart';
import 'package:client/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api{
  static const trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const bingeWorthyUrl = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const newReleasesUrl = 'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';

  Future<List<Movie>> getTrendingMovies() async{
    // Make a network call to the trending movies endpoint
    // Parse the JSON response into a list of Movie objects
    // Return the list of Movie objects
    final response = await http.get(Uri.parse(trendingUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      print('Trending: ${decodeData}');
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
      print('BingeWorthy: ${decodeData}');
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
      print('New Releases: ${decodeData}');
      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    }else{
      throw Exception('Failed to load movies');
    }
  }
}