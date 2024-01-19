class UserModel {
  late String id;
  final String email;
  final String firstName;
  final String lastName;
  final String userName;
  final List<String> favoritesMovies;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.favoritesMovies,
  });

  factory UserModel.fromJson(Map<String, dynamic>? data) {
    return UserModel(
      id: data?['id'] ?? '',
      email: data?['email'] ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      userName: data?['userName'] ?? '',
      favoritesMovies: List<String>.from(data?['favoritesMovies'] ?? []),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'favoritesMovies': favoritesMovies,
    };
  }
}