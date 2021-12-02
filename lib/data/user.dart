import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static String collectionName = 'users';
  String id;
  String userName;
  String firstName;
  String lastName;
  String email;

  User(
      {required this.id,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.email});

  User.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String,
            userName: json['userName'] as String,
            firstName: json['firstName'] as String,
            lastName: json['lastName'] as String,
            email: json['email'] as String);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName
    };
  }

  static CollectionReference<User> withConverter() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<User>(
          fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }
}
