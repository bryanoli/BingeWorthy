import 'package:flutter/material.dart';
import 'package:client/components/menu_drawer.dart';
import 'package:client/database/database.dart';
import 'userbingelist.dart';

class WorldsList extends StatefulWidget {
  const WorldsList({super.key});

  @override
  State<WorldsList> createState() => _WorldsListState();
}

class _WorldsListState extends State<WorldsList> {

  late Future<List> usernames;
  late DataBaseService databaseService;

  @override
  void initState(){
    super.initState();
    databaseService = DataBaseService();
    usernames = databaseService.getAllUsernames();
  }

  void navigateToUserBingeList(String username){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => BingeListForUsers(username:username,)));
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
          FutureBuilder(future: usernames, builder: (context, snapshot) {
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
                  final clickedUser = snapshot.data?[index];
                  return ListTile(
                    title: Text(clickedUser),
                    onTap: () {
                      navigateToUserBingeList(clickedUser);
                    },
                  );
                },
                childCount: snapshot.data?.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}