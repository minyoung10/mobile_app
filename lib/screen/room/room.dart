// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../info/user.dart';
import '../../themepage/theme.dart';
import '../bottom/home.dart';
import 'tab/accounting.dart';
import 'tab/meeting.dart';
import 'tab/notification.dart';

class Room extends StatefulWidget {
  final String id;

  const Room({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ignore: unused_field, prefer_final_fields
  TextEditingController _roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StreamBuilder(
          stream: firestore.collection('Biginfo').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = snapshot.data!.docs;
            final filteredDocs =
                docs.where((doc) => doc['id'] == widget.id).toList();

            if (filteredDocs.isNotEmpty) {
              final roomSnapshot = filteredDocs.first;
              final roomData = roomSnapshot.data();

              return Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 349,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                            child: Image.network(
                              roomData['roomImage'].toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 62,
                          left: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/'));
                            },
                            color: Colors.white,
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 77,
                          right: 25,
                          child: GestureDetector(
                            onTap: () async {
                              _showBottomSheet(context, '1');
                            },
                            child: Container(
                              width: 30,
                              height: 18,
                              child: Image.asset('assets/images/kebap.png'),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 236,
                          left: 25,
                          child: Container(
                            child: Text(roomData['title'],
                                style: whitew700.copyWith(
                                  fontSize: 24.0,
                                )),
                          ),
                        ),
                        Positioned(
                          top: 270,
                          left: 25,
                          child: Container(
                            width: 159,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(3), // 반지름 값을 설정합니다.
                              color: Color.fromRGBO(255, 239, 244, 1),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 12, bottom: 3),
                                  child: Text(roomData['mission'],
                                      style: pinkw700.copyWith(
                                        fontSize: 16.0,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 317),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 379,
                                    height: 50,
                                    child: TabBar(
                                      indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                          width: 2, // Bottom line width
                                        ), // Bottom line padding
                                        borderRadius: BorderRadius.circular(
                                            2), // Adjust the radius as needed
                                      ),
                                      indicatorWeight: 3,
                                      indicatorColor:
                                          Color.fromRGBO(36, 38, 37, 1),
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicatorPadding: EdgeInsets.only(
                                          bottom:
                                              1), // Adjust horizontal padding
                                      controller: _tabController,
                                      // label color
                                      labelColor: Color.fromRGBO(36, 38, 37, 1),
                                      // unselected label color
                                      unselectedLabelColor:
                                          Color.fromARGB(255, 151, 151, 151),

                                      tabs: [
                                        SizedBox(
                                          width: 90,
                                          child: Tab(
                                            child: Text(
                                              '공지사항',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18, // Font size
                                                fontWeight: FontWeight
                                                    .w700, // Font weight 700
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Tab(
                                            child: Text(
                                              '모임',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18, // Font size
                                                fontWeight: FontWeight
                                                    .w700, // Font weight 700
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Tab(
                                            child: Text(
                                              '회의록',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18, // Font size
                                                fontWeight: FontWeight
                                                    .w700, // Font weight 700
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Tab(
                                            child: Text(
                                              '정산',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18, // Font size
                                                fontWeight: FontWeight
                                                    .w700, // Font weight 700
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                  height: 0,
                                  color: Color.fromRGBO(170, 170, 170, 1))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 485,
                      width: 393,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MissionTab(id: widget.id),
                          MeetingTab(id: widget.id),
                          MissionTab(id: widget.id),
                          AccountingTab(id: widget.id),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text('');
            }

            ;
          }),
    );
  }

  void _showBottomSheet(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(23.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 160,
          child: Container(
            margin: EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 343,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF242625),
                      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 모서리 반경 설정
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showDeleteConfirmationDialog(context);
                    },
                    child: Text(
                      "삭제",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Color.fromRGBO(239, 0, 0, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                Container(
                  width: 343,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF242625),
                      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 모서리 반경 설정
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(36, 38, 37, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.transparent,
          contentPadding: EdgeInsets.all(0), // padding을 0으로 설정
          insetPadding: EdgeInsets.all(16), // 화면 주변 padding 설정
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            width: 343, // 원하는 가로 길이 설정
            height: 139, // 원하는 세로 길이 설정
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 29),
                Text("이 글을 정말 삭제하시겠어요?",
                    style: blackw500.copyWith(fontSize: 18)),
                SizedBox(height: 31),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 131,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Color(0xFF808080),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // 모서리 반경 설정
                          ),
                        ),
                        child:
                            Text("취소", style: whitew700.copyWith(fontSize: 14)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      width: 131,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Color(0xFFEF597D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // 모서리 반경 설정
                          ),
                        ),
                        child:
                            Text("삭제", style: whitew700.copyWith(fontSize: 14)),
                        onPressed: () async {
                          try {
                            // Replace "Biginfo" with the actual collection name
                            await FirebaseFirestore.instance
                                .collection("Biginfo")
                                .doc(widget.id)
                                .delete();
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          } catch (e) {
                            print("Error deleting document: $e");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
