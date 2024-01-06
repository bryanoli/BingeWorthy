import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../constants.dart';


class MovieBio {
  void showPopUp(BuildContext context,  Movie movie) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
      return AlertDialog(
        title: Text(movie.title),
        content: SizedBox(
          width: screenSize.width * 0.5,
          height: screenSize.height * 0.5,
          child: Column(
            children:[
              Image.network(
                '${Constants.imagePath}${movie.backDropPath}',
                fit: BoxFit.cover,
              ),
              Center(
                child: SizedBox(
                  child: Padding(padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text('Rating: ${movie.voteAverage}'),
                      const SizedBox(width: 8),
                      Text('Release Date: ${movie.releaseDate}'),
                    ],
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SizedBox(
                  height: screenSize.height * 0.8,
                  width: screenSize.width * 0.3,
                  child: SingleChildScrollView(
                    child: Text(movie.overView)),),
              ),
            ],
          ), 
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.favorite_border),),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the pop-up
            },
            child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}