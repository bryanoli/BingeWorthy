import 'package:flutter/material.dart';
import '../database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/custom_searchbar.dart';
import '../constants.dart';
import '../api/api.dart';
import '../models/movie.dart';
import 'package:reorderables/reorderables.dart';


class BingeList extends StatefulWidget {
  const BingeList({Key? key}) : super(key: key);

  @override
  State<BingeList> createState() => _BingeListState();
}

class _BingeListState extends State<BingeList> {
  late String? userId;
  late DataBaseService databaseService;
  late List<String> userFavorites;
  // final ScrollController _scrollController = ScrollController();
  Api api = Api();


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
        // Handle the case where current user ID is null
        print('Current user ID is null.');
      }
    } catch (error) {
      // Handle error if needed
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

  void signOut() async {
    final currentContext = context;
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(currentContext, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FlutterFlix',
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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Use the same color as the background
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Bingelist'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/bingelist');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
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
    );
  }
}