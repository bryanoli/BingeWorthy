import 'package:client/components/menu_drawer.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/custom_searchbar.dart';
import '../constants.dart';
import '../api/api.dart';
import '../models/movie.dart';


class BingeList extends StatefulWidget {
  const BingeList({super.key});

  @override
  State<BingeList> createState() => _BingeListState();
}

class _BingeListState extends State<BingeList> {
  late String? userId;
  late DataBaseService databaseService;
  late List<String> userFavorites;
  // final ScrollController _scrollController = ScrollController();
  Api api = Api();

  Future<void> updateUserFavoritesOrder(List<String> newOrder) async {
    try {
      if (userId != null) {
        await databaseService.updateUserFavoritesOrder(userId!, newOrder);
      } else {
        print('Current user ID is null.');
      }
    } catch (error) {
      print('Error updating user favorites order: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    databaseService = DataBaseService();
    userFavorites = [];

    fetchUserFavorites();
  }

  Future<void> fetchUserFavorites() async {
    try {
      if (userId != null) {
        // Fetch user's favorite movies
        List<String> favorites = await databaseService.getUserFavoritesMovies(userId!);

        // Update the state with the fetched data
        setState(() {
          userFavorites = favorites;
        });
      } else {
        print('Current user ID is null.');
      }
    } catch (error) {
      print('Error fetching user favorites: $error');
    }
  }

  Future<Map<String, String>> fetchMovieData(String title, ) async {
    Movie movie = await api.searchMovie(title);
    return {
      'title': movie.title,
      'posterPath': movie.posterPath,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bingelist',
          style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            icon: const Icon(Icons.home),
          ),
          CustomSearchBar(),
        ],
      ),
      drawer: const MenuDrawer(),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < userFavorites.length; index += 1)
            ReorderableDragStartListener(
              index: index,
              key: ValueKey(index),
              child: ListTile(
                key: ValueKey(index),
                leading: FutureBuilder(
                  future: fetchMovieData(userFavorites[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final Map<String, String> movieData = snapshot.data as Map<String, String>;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            filterQuality: FilterQuality.high,
                            '${Constants.imagePath}${movieData['posterPath']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return const Text('Unknown error occurred');
                    }
                  },
                ),
                title: Text('${index + 1}. ${userFavorites[index]}'),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String movie = userFavorites.removeAt(oldIndex);
            userFavorites.insert(newIndex, movie);
          });
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              databaseService.clearUserFavorites(userId!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favorites list cleared!'),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BingeList()),
              );
            },
            child: const Icon(Icons.delete),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              updateUserFavoritesOrder(userFavorites);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favorites list updated!'),
                ),
              );
            },
            child: const Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}