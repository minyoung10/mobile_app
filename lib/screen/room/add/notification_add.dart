// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../info/big.dart';
import '../../../themepage/theme.dart';

class AddNotification extends StatefulWidget {
  final String id;

  const AddNotification({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  int? selectedDropdownValue; // 드롭다운에서 선택된 값을 저장하는 변수
  String selectedDropdownText = ''; // 기본 값 설정

  final TextEditingController _titleController = TextEditingController();
  bool _isTextFieldEmpty = true;
  String _enteredText = '';

  final TextEditingController _textFieldController = TextEditingController();

  XFile? _pickedFile;
  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      appBar: AppBar(
        title: Text('공지 작성'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목을 입력해 주세요'),
              TextFormField(
                maxLength: 15,
                key: const ValueKey(1),
                style: blackw500.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  //준) 선택되지 않은 밑줄 속성
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  //준) 선택된 밑줄 속성 둘을 일치시켰음
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  hintText: "예) 전산전자 공학부 임원단",
                  hintStyle: greyw500.copyWith(fontSize: 14),
                  suffixIcon: _isTextFieldEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.cancel),
                          iconSize: 15,
                          color: Colors.grey,
                          onPressed: () {
                            _titleController.clear();
                            setState(() {
                              _enteredText = '';
                              _isTextFieldEmpty = true;
                            });
                          },
                        ),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredText = value;
                    _isTextFieldEmpty = value.isEmpty;
                  });
                },
                onSaved: (value) {
                  _enteredText = value!;
                },
              ),
              Text('내용을 입력해 주세요'),
              SizedBox(height: 5),
              TextField(
                controller: _textFieldController,
                maxLength: 300,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text('사진을 추가해 주세요'),
              GestureDetector(
                  onTap: () {
                    _getPhotoLibraryImage();
                  },
                  child: Column(children: [
                    _pickedFile != null
                        ? Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            height: 256,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: FileImage(File(_pickedFile!.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            height: 256,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.photo_library,
                            ),
                          ),
                  ])),
              SizedBox(height: 40),
              Container(
                width: 343,
                height: 45,
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: ElevatedButton(
                  onPressed: () async {
                    final docRef = FirebaseFirestore.instance
                        .collection("Smallinfo")
                        .doc(widget.id);
                    final notificationRef =
                        docRef.collection("notifications").doc();
                    await notificationRef.set({
                      "title": _enteredText,
                      "context": _textFieldController.text,
                      "image": BigInfoProvider.roomImage,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                      ),
                      backgroundColor: Color.fromRGBO(54, 209, 0, 1)),
                  child: const Text(
                    '완료하기',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _generateRandom4Digit() {
    final random = Random();
    int fourDigitRandom = random.nextInt(10000); // 0부터 9999까지의 난수 생성
    String formattedRandom = fourDigitRandom.toString().padLeft(4, '0');
    BigInfoProvider.code = formattedRandom;
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      _uploadImageToFirebase();
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  String? _uploadedImageUrl; // 업로드 된 이미지 URL 저장 변수 추가
  Future<String> _getUploadedImageUrl(Reference ref) async {
    return await ref.getDownloadURL();
  }

  _uploadImageToFirebase() async {
    await Firebase.initializeApp();
    // 선택한 이미지가 있는지 확인
    if (_pickedFile == null) {
      if (kDebugMode) {
        print('이미지가 선택되지 않았습니다.');
      }
      return;
    }
    // 선택한 파일에서 이미지 데이터 읽기
    final imageBytes = await File(_pickedFile!.path).readAsBytes();
    // Firebase Storage에 이미지를 업로드할 위치에 대한 참조 생성
    final imageName = DateTime.now().microsecond.toString() + '.jpg';
    final storageReference = FirebaseStorage.instance.ref(imageName);

    try {
      // 이미지를 Firebase Storage에 업로드
      await storageReference.putData(imageBytes);
      final TaskSnapshot taskSnapshot =
          await storageReference.putData(imageBytes);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _uploadedImageUrl = imageUrl; // 업로드 된 이미지 URL 저장
        BigInfoProvider.roomImage = _uploadedImageUrl;
      });
      if (kDebugMode) {
        print('이미지 업로드 성공\n');
      }
    } catch (e) {
      if (kDebugMode) {
        print('이미지 업로드 실패: $e');
      }
    }
  }
}
