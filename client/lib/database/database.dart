import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class DataBaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> saveUserToDatabase(String? uid, String? email, String? firstName, String? lastName, String? userName, List<String>? favoritesMovies) async {
    if (uid != null && email != null && firstName != null && lastName != null && userName != null && favoritesMovies != null) {
      DatabaseReference userRef = databaseReference.child('users').child(uid);
      await userRef.set({
        'id': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'favoritesMovies': favoritesMovies,
      });
      print('User added to database!');
    }
  }

  Future<List<String>> getUserFavoritesMovies(String userId) async {
    List<String> favoritesMovies = [];
    DatabaseReference userRef = databaseReference.child('users').child(userId);
    DataSnapshot snapshot = (await userRef.once()).snapshot;
    if (snapshot.value != null) {
      UserModel user = UserModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map<String, dynamic>? ?? {}));
      favoritesMovies = user.favoritesMovies;
    }
    return favoritesMovies;
  }

  Future<void> addUserFavoriteMovie(String newFavoriteMovie) async {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;
        DatabaseReference userRef = databaseReference.child('users').child(userId);
        // Get the current user's favorites movies
        List<String> favoritesMovies = await getUserFavoritesMovies(userId);
        // Add the new favorite movie to the list
        favoritesMovies.add(newFavoriteMovie);
        // Update the user's favorites movies
        await userRef.update({
          'favoritesMovies': favoritesMovies,
        });
      }
  }
}