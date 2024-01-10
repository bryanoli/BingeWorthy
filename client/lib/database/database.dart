import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/user.dart';

class DataBaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> saveUserToDatabase(String? uid, String email, String firstName, String lastName, String userName, List<String> favoritesMovies) async {
    if (uid != null) {
      DatabaseReference userRef = databaseReference.child('users').child(uid);
      userRef.set({
        'id': uid, // This is the user's unique ID from Firebase Authentication 'UserCredential
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'favoritesMovies': favoritesMovies,
        // Add other user details as needed
      });
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await databaseReference.child('users').push().set(user.toJson);
    } catch (error) {
      print('Error creating user: $error');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await databaseReference.child('users').child(user.id).update(user.toJson());
    } catch (error) {
      print('Error updating user: $error');
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await databaseReference.child('users').child(user.id).remove();
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

Future<List<UserModel>> getUsers() async {
  try {
    final users = <UserModel>[];
    final snapshot = await databaseReference.child('users').once();

    if (snapshot.snapshot.value != null) {
      (snapshot.snapshot.value as Map<String, dynamic>).forEach((key, value) {
        if (value != null && value is Map<String, dynamic>) {
          final user = UserModel.fromJson(value);
          user.id = key;
          users.add(user);
        }
      });
    }

    return users;
  } catch (error) {
    print('Error getting users: $error');
    rethrow;
  }
}
}