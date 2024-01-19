import 'package:flutter/material.dart';
import 'package:client/api/api.dart'; // Import your Api class
import 'package:client/models/movie.dart'; // Import your Movie class
import 'package:client/constants.dart';
import 'package:client/screens/movie_bio.dart';

class CustomSearchBar extends StatelessWidget {
  final Api api = Api();

  CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: 'Search for a movie',
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) async {
        if (controller.text.isEmpty) {
          return const <Widget>[]; // Return an empty list for no suggestions
        }

        try {
          final List<Movie> options = await api.searchMovies(controller.text);

          if (options.isEmpty) {
            return <Widget>[
              const ListTile(
                title: Text('No matching movies found'),
              ),
            ];
          }

          return List.generate(options.length, (int index) {
            final Movie movie = options[index];
            return ListTile(
              leading: Image.network(
                '${Constants.imagePath}${movie.posterPath}',
                fit: BoxFit.cover,
              ),
              title: Text(movie.title),
              onTap: () {
                MovieBio().showPopUp(context, movie);
              },
            );
          });
        } catch (error) {
          return <Widget>[
            ListTile(
              title: Text('Error loading search results: $error'),
            ),
          ];
        }
      },
    );
  }
}
