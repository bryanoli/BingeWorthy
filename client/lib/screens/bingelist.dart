import 'package:flutter/material.dart';
import '../database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/custom_searchbar.dart';
import '../constants.dart';

class BingeList extends StatefulWidget {
  const BingeList({Key? key}) : super(key: key);

  @override
  State<BingeList> createState() => _BingeListState();
}

class _BingeListState extends State<BingeList> {
  late String? userId;
  late DataBaseService databaseService;
  late List<String> userFavorites;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    databaseService = DataBaseService();
    userFavorites = [];

    // Fetch user favorites when the widget is initialized
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

  Future<Map<String, String>> fetchMovieData(String title) async {
    // Placeholder function to fetch movie data based on the title
    // You should replace this with your actual logic/API call
    // Return a map containing at least the title and poster path
    return {
      'title': title,
      'posterPath': 'path/to/placeholder/poster.jpg',
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
              leading: Icon(Icons.person),
              title: Text('Dashboard'),
              onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Bingelist'),
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'FlutterFlix',
              style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            pinned: true,
            floating: true,
            expandedHeight: 200,
            actions: [
              CustomSearchBar(),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FutureBuilder(
                  future: fetchMovieData(userFavorites[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // Data is available, build the ListTile
                      final Map<String, String> movieData = snapshot.data as Map<String, String>;
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 300,
                            width: 200,
                            child: Image.network(
                              filterQuality: FilterQuality.high,
                              '${Constants.imagePath}${movieData['posterPath']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text('${index + 1}. ${movieData['title']}'),
                      );
                    } else {
                      return Text('Unknown error occurred');
                    }
                  },
                );
              },
              childCount: userFavorites.length,
            ),
          ),
        ],
      ),
    );
  }
}