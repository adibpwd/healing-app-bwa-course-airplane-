import 'package:airplane/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> setUser(UserModel user) async {
    try {
      _userReference.doc(user.id).set({
        "email": user.email,
        "name": user.name,
        "hobby": user.hobby,
        "balance": user.balance,
        "imageUrl": user.imageUrl,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<String> getUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      return user!.uid;
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();

      return UserModel(
        id: id,
        email: snapshot['email'],
        name: snapshot['name'],
        hobby: snapshot['hobby'],
        balance: snapshot['balance'],
        imageUrl: snapshot['imageUrl'],
      );
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> update(String id, Map<String, dynamic> user) async {
    try {
      _userReference.doc(id).update(user);

      return UserModel.fromJson(id, user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      user!.updatePassword(newPassword);
    } catch (e) {
      throw e;
    }
  }
}
