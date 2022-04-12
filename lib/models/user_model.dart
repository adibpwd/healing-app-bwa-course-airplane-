import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String hobby;
  final int balance;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.hobby = '',
    this.balance = 0,
    this.imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/airplane-6998a.appspot.com/o/users%2Fprofile.png?alt=media&token=b61941be-35ef-4cb2-9654-dfcb6754279f',
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      name: json['name'],
      email: json['email'],
      hobby: json['hobby'],
      balance: json['balance'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, hobby, balance, imageUrl];
}
