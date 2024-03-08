import 'package:client/constants.dart';
import 'package:client/screens/movie_bio.dart';
import 'package:flutter/material.dart';
import '../components/menu_drawer.dart';
import 'package:client/database/database.dart';
import '../api/api.dart';
import '../models/movie.dart';

class BingeListForUsers extends StatefulWidget {
  const BingeListForUsers({required this.username, super.key});

  final String username;

  @override
  State<BingeListForUsers> createState() => _BingeListForUsersState();
}

class _BingeListForUsersState extends State<BingeListForUsers> {

  late Movie movie;
  late String clickedUser;
  late DataBaseService databaseService;
  late List<String> userFavorites;
      Api api = Api();

  @override
  void initState() {
    super.initState();
    databaseService = DataBaseService();
    userFavorites = [];
    clickedUser = widget.username;
    fetchUserFavorites();
  }


  Future<void> fetchUserFavorites() async {
    try {
      // Fetch user's favorite movies
      List<String> favorites = await databaseService.getUserFavoritesMovies(clickedUser);

      // Update the state with the fetched data
      setState(() {
        userFavorites = favorites;
      });
        } catch (error) {
      print('Error fetching user favorites: $error');
    }
  }

  Future<Map<String, String>> fetchMovieData(String title) async {
    Movie movie = await api.searchMovie(title);
    return {
      'title': movie.title,
      'posterPath': movie.posterPath,
    };
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'FlutterFlix',
              style: TextStyle(color: Colors.blue,fontSize: 24, fontWeight: FontWeight.bold),
            ),
            pinned: true,
            floating: true,
            expandedHeight: 200,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                icon: const Icon(Icons.home),
              ),
            ],
          ),
        FutureBuilder<List<String>>(
          future: databaseService.getUserFavoritesMovies(clickedUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Text('Error fetching data: ${snapshot.error}'),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
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

                    title: Text(userFavorites[index]),
                    onTap: () async{
                      movie = await api.searchMovie(userFavorites[index]);
                      MovieBio().showPopUp(context, movie);
                    },
                  );
                },
                childCount: userFavorites.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}