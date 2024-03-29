import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class DataBaseService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserToDatabase(String? uid, String? email, String? firstName, String? lastName, String? userName, List<String>? favoritesMovies) async {
    if (uid != null && email != null && firstName != null && lastName != null && userName != null && favoritesMovies != null) {
      DocumentReference userRef = usersCollection.doc(uid);
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

  Future<UserModel?> getUserFromDatabase() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
      if (snapshot.exists) {
        UserModel user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {});
        print('User found in database: ${user.firstName}');
        return user;
      }
    }
    return null;
  }

  Future<List<String>> getAllUsernames() async{
    List<String> usernames = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await usersCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        // Assuming 'userName' field is present in each document
        String username = doc['userName'];
        usernames.add(username);
      }

      return usernames;
    } catch (e) {
      print('Error retrieving usernames: $e');
      return [];
    }
  }

Future<List<String>> getUserFavoritesMovies(String username) async {
  List<String> favoritesMovies = [];

  QuerySnapshot querySnapshot = await usersCollection.where('userName', isEqualTo: username).get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot snapshot = querySnapshot.docs.first;
    
    UserModel user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {});
    favoritesMovies = user.favoritesMovies;
  }

  return favoritesMovies;
}

  Future<List<String>> getCurrentUserFavoritesMovies(String userId) async {
    List<String> favoritesMovies = [];
    DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
    if (snapshot.exists) {
      UserModel user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {});
      favoritesMovies = user.favoritesMovies;
    }
    return favoritesMovies;
  }

  Future<void> addUserFavoriteMovie(String newFavoriteMovie) async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentReference userRef = usersCollection.doc(userId);
      // Get the current user's favorites movies
      List<String> favoritesMovies = await getCurrentUserFavoritesMovies(userId);
      // Add the new favorite movie to the list
      favoritesMovies.add(newFavoriteMovie);
      // Update the user's favorites movies
      await userRef.update({
        'favoritesMovies': favoritesMovies,
      });
    }
  }

  Future<void> updateUserFavoritesOrder(String userId, List<String> newOrder) async {
    try {
      await usersCollection.doc(userId).update({
        'favoritesMovies': newOrder,
      });
      print('User favorites order updated successfully!');
    } catch (error) {
      print('Error updating user favorites order: $error');
    }
  }

  Future<void> clearUserFavorites(String userId) async {
    try {
      await usersCollection.doc(userId).update({
        'favoritesMovies': FieldValue.delete(),
      });
      print('User favorites cleared successfully!');
    } catch (error) {
      print('Error clearing user favorites: $error');

    }
  }
}