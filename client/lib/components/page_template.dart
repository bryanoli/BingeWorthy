// import 'package:flutter/material.dart';

// class PageTemplate extends StatelessWidget {
//   const PageTemplate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue, // Use the same color as the background
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             const ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//             ),
//             const ListTile(
//               leading: Icon(Icons.list),
//               title: Text('Bingelist'),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () {
//                 signOut();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }