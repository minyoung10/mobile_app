import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../themepage/theme.dart';

class AccountingTab extends StatefulWidget {
  final String id;
  const AccountingTab({super.key, required this.id});
  @override
  State<AccountingTab> createState() => AccountingTabState();
}

class AccountingTabState extends State<AccountingTab> {
  final firestore = FirebaseFirestore.instance;
  XFile? _pickedFile;
  String? roomDataId;
  String? userindex;

  int? image_count;
  int? check_count = 0;
  var scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _imageSize = MediaQuery.of(context).size.width / 4;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
        return GestureDetector(
            onTap: () {
              _getPhotoLibraryImage();
            },
            child: Column(
              children: [
                _pickedFile != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 25),
                        width: 343,
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
                        margin: const EdgeInsets.only(top: 25),
                        width: 343,
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
                const SizedBox(height: 38),
                Container(
                  width: 343,
                  height: 45,
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
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
            ));
      },
    );
  }

  void _showStyledSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🥳 미션을 성공했어요!',
            style: TextStyle(
              color: Color(0xFFEF597D), //글씨는 분명히 보여야 함으로 투명도 미적용
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFEFF4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: const EdgeInsets.only(
        left: 72.0,
        right: 72.0,
        bottom: 84,
      ),
      elevation: 0.0,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
            height: 278,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23), color: Colors.white),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23), color: Colors.white),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: 48,
                        height: 3.346,
                        decoration: BoxDecoration(
                          color: const Color(0xFFAAAAAA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 14),
                      child: Text(
                        '방에 들어갈 이미지는 무엇인가요?',
                        style:
                            blackw700.copyWith(fontSize: 18, letterSpacing: -1),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Text(
                        "이미지를 가져올 곳을 선택해주세요",
                        style:
                            greyw500.copyWith(fontSize: 14, letterSpacing: -1),
                      ),
                    ),
                    Container(
                      width: 343,
                      height: 60,
                      margin:
                          const EdgeInsets.only(left: 25, right: 25, top: 38),
                      child: ElevatedButton(
                        onPressed: () {
                          _getPhotoLibraryImage();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                          ),
                          elevation: 0, // 이 부분을 추가하여 쉐도우 없앰
                          backgroundColor:
                              const Color.fromRGBO(255, 239, 244, 1),
                        ),
                        child: const Text(
                          '갤러리',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(239, 89, 125, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
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
  Future<void> _uploadImageToFirebase() async {
    await Firebase.initializeApp();

    if (_pickedFile == null) {
      if (kDebugMode) {
        print('이미지가 선택되지 않았습니다.');
      }
      return;
    }

    final imageBytes = await File(_pickedFile!.path).readAsBytes();
    final imageName = '${DateTime.now().second}.jpg';
    final storageReference = FirebaseStorage.instance.ref(imageName);

    try {
      await storageReference.putData(imageBytes);
      final TaskSnapshot taskSnapshot =
          await storageReference.putData(imageBytes);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = imageUrl;
      });
      final docRef = firestore.collection('Biginfo').doc(roomDataId);
      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      Map<String, dynamic> usersImage = data['users_image'] ?? {};
      usersImage[userindex!] = _uploadedImageUrl!;

      await docRef.update({
        'users_image': usersImage,
      });
    } catch (e) {
      if (kDebugMode) {
        print('이미지 업로드 실패: $e');
      }
    }
  }
}
