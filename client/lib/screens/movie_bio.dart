import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../constants.dart';

class MovieBio extends StatelessWidget {
  const MovieBio({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the movie details passed as arguments
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(movie.title),
            background: Image.network(
              '${Constants.imagePath}${movie.backDropPath}',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overView,
                      style: TextStyle(fontSize: 16),
                    ),
                    // Add more details as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}