import 'package:flutter/material.dart';
import 'package:client/database/database.dart';
import 'package:client/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late Future<UserModel?> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = DataBaseService().getUserFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Use the same color as the background
              ),
              child: FutureBuilder<UserModel?>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text('Welcome, ${snapshot.data!.userName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
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
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
    );
  }
}