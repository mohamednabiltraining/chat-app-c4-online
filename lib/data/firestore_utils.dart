import 'package:chat_app_c4_online/data/room.dart';
import 'package:chat_app_c4_online/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserToFireStore(User user) {
  return User.withConverter().doc(user.id).set(user);
}

Future<void> addRoomToFireStore(Room room) {
  var docRef = Room.withConverter().doc();
  room.id = docRef.id;
  return docRef.set(room);
}

Future<User?> getUserById(String id) async {
  DocumentSnapshot<User> result = await User.withConverter().doc(id).get();
  return result.data();
}
