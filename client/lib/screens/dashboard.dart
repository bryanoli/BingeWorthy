import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';
import '../api/api.dart';
import '../components/carousel_builder.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> bingeWorthyMovies;
  late Future<List<Movie>> newReleases;

  void signOut() async {
    final currentContext = context;
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(currentContext, '/login');
  }

  final List<String> carouselTitles = [
    'New Releases',
    'Binge Worthy',
    'Top Trending',
  ];

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    bingeWorthyMovies = Api().getTopRated();
    newReleases = Api().getNewReleases();
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
            const ListTile(
              title: Text('History'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
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
              style: TextStyle(color: Colors.blue,fontSize: 24, fontWeight: FontWeight.bold),
            ),
            pinned: true,
            floating: true,
            expandedHeight: 200,
            actions: [
              IconButton(
                onPressed: () {
                  print('Search icon tapped');
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Return a header widget for each carousel item
                return Column(
                  children: [
                    // Header
                    ListTile(
                      title: Text(
                        carouselTitles[index],
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: FutureBuilder(
                        future:index == 0 ? newReleases : (index == 1 ? bingeWorthyMovies : trendingMovies),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return WorthySliders(snapshot: snapshot);
                          } else if (snapshot.hasError) {
                            return Center(child: Text('${snapshot.error}'));
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ],
                );
              },
              childCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
