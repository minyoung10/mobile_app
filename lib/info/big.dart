import 'package:cloud_firestore/cloud_firestore.dart';

class BigInfoProvider {
  static String? code;
  static String? codeInFireStore;
  static String? id;
  static String? idInFireStore;
  static String? title;
  static String? titleInFireStore;
  static String? mission;
  static String? missionInFireStore;
  static String? job;
  static String? jobInFireStore;
  static String? roomImage;
  static String? roomImageInFireStore;
  static String? registerTime;
  static String? registerTimeInFireStore;
  static List? users_id;
  static List? users_idInFireStore;
  static List? users_name;
  static List? users_nameInFireStore;
  static String? start_date;
  static String? end_date;
  static String? start_time;
  static String? end_time;

  static String? image;
  static String? rimage;
  static Map? users_image;
  static Map? users_imageInFireStore;
}

class BigInfo {
  final String? code;
  final String? id;
  final String? title;
  final String? mission;
  final String? roomImage;
  final Timestamp? registerTime;
  final List? users_id;
  final List? users_name;
  final Map? users_image;
  final String? start_date;
  final String? end_date;
  final String? start_time;
  final String? end_time;

  BigInfo({
    required this.code,
    required this.id,
    required this.title,
    required this.mission,
    required this.roomImage,
    required this.registerTime,
    required this.users_id,
    required this.users_name,
    required this.users_image,
    required this.start_date,
    required this.end_date,
    required this.start_time,
    required this.end_time,
  });

  factory BigInfo.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return BigInfo(
      code: snapshotData[codeFieldName],
      id: snapshotData[idFieldName],
      title: snapshotData[titleFieldName],
      mission: snapshotData[missionFieldName],
      roomImage: snapshotData[roomImageFieldName],
      registerTime: snapshotData[registerTimeFieldName],
      users_id: snapshotData[users_idFieldName],
      users_name: snapshotData[users_nameFieldName],
      users_image: snapshotData[users_imageFieldName],
      start_date: snapshotData[users_imageFieldName],
      end_date: snapshotData[users_imageFieldName],
      start_time: snapshotData[users_imageFieldName],
      end_time: snapshotData[users_imageFieldName],
    );
  }
}

const String codeFieldName = 'code';
const String idFieldName = 'id';
const String titleFieldName = "title";
const String missionFieldName = "mission";
const String roomImageFieldName = 'roomImage';
const String registerTimeFieldName = "register-time";
const String users_idFieldName = "users_id";
const String users_nameFieldName = "users_name";
const Map users_imageFieldName = {"users_id": 'users_image'};
const String start_dateFieldName = "start_date";
const String end_dateFieldName = "end_date";
const String start_timeFieldName = "start_time";
const String end_timeFieldName = "end_time";
