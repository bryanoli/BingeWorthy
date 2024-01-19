import 'package:client/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './authentication/login.dart';
import './authentication/register.dart';
import './screens/dashboard.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      color: Color.fromARGB(255, 5, 131, 185),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30),
      ),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/dashboard': (context) => const Dashboard(),
      },
      home: const Login(),
    );
  }
}

// class AuthStateObserver extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // You can show a loading indicator if needed
//           return const CircularProgressIndicator();
//         } else {
//           final isUserSignedIn = snapshot.hasData;
//           // Depending on the authentication state, navigate to the corresponding screen
//           if (isUserSignedIn) {
//             return Dashboard();
//           } else {
//             return Login();
//           }
//         }
//       },
//     );
//   }
// }

