import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  static String? userName;
  static String? userNameInFireStore;
  static String? userEmail;
  static String? userEmailInFireStore;

  static String? userPassword;
  static String? userPasswordInFireStore;
  static String? userId;
  static String? userIdInFireStore;
}

class joyUser {
  joyUser({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userId,
  });

  final String? userName;
  final String? userEmail;
  final String? userPassword;
  final String? userId;

  factory joyUser.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return joyUser(
        userName: snapshotData[userNameFieldName],
        userEmail: snapshotData[userEmailFieldName],
        userPassword: snapshotData[userPasswordFieldName],
        userId: snapshotData[userIdFieldName]);
  }
}

const String userNameFieldName = "userName";
const String userEmailFieldName = "userEamil";
const String userPasswordFieldName = "userPassword";
const String userIdFieldName = "userId";
