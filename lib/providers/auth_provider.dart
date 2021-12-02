import 'package:chat_app_c4_online/data/firestore_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_c4_online/data/user.dart' as AppUser;

class AuthProvider extends ChangeNotifier {
  AppUser.User? user = null;

  AuthProvider() {
    fetchFireStoreUser();
  }

  void updateUser(AppUser.User user) {
    this.user = user;
    notifyListeners();
  }

  void fetchFireStoreUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var fireStoreUser =
          await getUserById(FirebaseAuth.instance.currentUser!.uid);
      user = fireStoreUser;
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
