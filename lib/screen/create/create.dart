// // ignore_for_file: prefer_const_constructors
// import 'dart:io';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../info/big.dart';
// import '../../info/user.dart';
// import '../room/room.dart';

// class CreateRoom extends StatefulWidget {
//   @override
//   _CreateRoomState createState() => _CreateRoomState();
// }

// class _CreateRoomState extends State<CreateRoom> {
//   int? selectedDropdownValue; // 드롭다운에서 선택된 값을 저장하는 변수
//   String selectedDropdownText = ''; // 기본 값 설정

//   final TextEditingController _textFieldController =
//       TextEditingController(); // 텍스트 필드의 값을 제어하기 위해서 씀

//   XFile? _pickedFile;
//   @override
//   Widget build(BuildContext context) {
//     final _imageSize = MediaQuery.of(context).size.width / 4;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Second Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(child: Text('친구들과 오늘부터 같이 할 미션 방을 만들어주세요.')),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//               width: _imageSize,
//               height: _imageSize,
//               child: _pickedFile != null
//                   ? Container(
//                       width: _imageSize,
//                       height: _imageSize,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         border: Border.all(
//                             width: 2,
//                             color: Theme.of(context).colorScheme.primary),
//                         image: DecorationImage(
//                             image: FileImage(File(_pickedFile!.path)),
//                             fit: BoxFit.cover),
//                       ),
//                     )
//                   : _uploadedImageUrl != null
//                       ? Image.network(_uploadedImageUrl!)
//                       : GestureDetector(
//                           onTap: () {
//                             _showBottomSheet();
//                           },
//                           child: Center(
//                             child: Icon(
//                               Icons.account_circle,
//                               size: _imageSize,
//                             ),
//                           ),
//                         ),
//             ),
//             Text('방 제목'),
//             SizedBox(height: 5),
//             TextField(
//               controller: _textFieldController, // 텍스트 필드의 값을 컨트롤러와 연결
//               maxLength: 15, // 최대 문자 길이 설정
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('미션 선택'),
//                         SizedBox(height: 5),
//                         DropdownButton<int>(
//                           isExpanded: true,
//                           value: selectedDropdownValue, // 현재 선택된 드롭다운 메뉴 값
//                           items: const [
//                             DropdownMenuItem(value: 1, child: Text('빨래')),
//                             DropdownMenuItem(value: 2, child: Text('밥먹기')),
//                             DropdownMenuItem(value: 3, child: Text('설거지하기')),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedDropdownValue =
//                                   value; // 드롭다운 메뉴에서 선택된 값 변경
//                               selectedDropdownText = _getDropdownText(
//                                   value); // 선택된 value에 따른 텍스트 설정
//                               BigInfoProvider.mission = selectedDropdownText;
//                             });
//                           },
//                           hint: Text('미션을 선택해주세요'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               children: const [Text("인증시간"), Card()],
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 print(BigInfoProvider.roomImage);
//                 _generateRandom4Digit();
//                 BigInfoProvider.title = _textFieldController.text;
//                 final docRef =
//                     FirebaseFirestore.instance.collection("Biginfo").doc();
//                 await docRef.set({
//                   registerTimeFieldName: FieldValue.serverTimestamp(),
//                   idFieldName: docRef.id,
//                   "title": BigInfoProvider.title,
//                   "mission": BigInfoProvider.mission,
//                   "roomImage": BigInfoProvider.roomImage,
//                   "code": BigInfoProvider.code,
//                   "users_id": [UserProvider.userId],
//                   "users_name": [UserProvider.userName],
//                   'users_image': {}
//                 });
//                 final docSnapshot = await docRef.get();
//                 if (docSnapshot.data() == null) {
//                   return;
//                 }
//                 final snapshotData = docSnapshot.data()!;

//                 BigInfoProvider.id = snapshotData[idFieldName];
//                 BigInfoProvider.title = snapshotData[titleFieldName];
//                 BigInfoProvider.code = snapshotData[codeFieldName];
//                 BigInfoProvider.missionInFireStore =
//                     snapshotData[missionFieldName];
//                 BigInfoProvider.roomImageInFireStore =
//                     snapshotData[roomImageFieldName];

//                 Navigator.pop(context);
//                 // ignore: use_build_context_synchronously
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Room(
//                       id: docRef.id,
//                       roomtitle: BigInfoProvider.title as String,
//                       roomimage: BigInfoProvider.roomImage as String,
//                       roommission: BigInfoProvider.mission as String,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('방 생성 완료'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _generateRandom4Digit() {
//     final random = Random();
//     int fourDigitRandom = random.nextInt(10000); // 0부터 9999까지의 난수 생성
//     String formattedRandom = fourDigitRandom.toString().padLeft(4, '0');
//     BigInfoProvider.code = formattedRandom;
//   }

//   _showBottomSheet() {
//     return showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(25),
//         ),
//       ),
//       builder: (context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             const Divider(
//               thickness: 3,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//               onPressed: () => _getPhotoLibraryImage(),
//               child: const Text('라이브러리에서 불러오기'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   _getPhotoLibraryImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _pickedFile = pickedFile;
//       });
//       _uploadImageToFirebase();
//     } else {
//       if (kDebugMode) {
//         print('이미지 선택안함');
//       }
//     }
//   }

//   String? _uploadedImageUrl; // 업로드 된 이미지 URL 저장 변수 추가
//   Future<String> _getUploadedImageUrl(Reference ref) async {
//     return await ref.getDownloadURL();
//   }

//   _uploadImageToFirebase() async {
//     await Firebase.initializeApp();
//     // 선택한 이미지가 있는지 확인
//     if (_pickedFile == null) {
//       if (kDebugMode) {
//         print('이미지가 선택되지 않았습니다.');
//       }
//       return;
//     }
//     // 선택한 파일에서 이미지 데이터 읽기
//     final imageBytes = await File(_pickedFile!.path).readAsBytes();
//     // Firebase Storage에 이미지를 업로드할 위치에 대한 참조 생성
//     final imageName = DateTime.now().microsecond.toString() + '.jpg';
//     final storageReference = FirebaseStorage.instance.ref(imageName);

//     try {
//       // 이미지를 Firebase Storage에 업로드
//       await storageReference.putData(imageBytes);
//       final TaskSnapshot taskSnapshot =
//           await storageReference.putData(imageBytes);
//       final imageUrl = await taskSnapshot.ref.getDownloadURL();
//       setState(() {
//         _uploadedImageUrl = imageUrl; // 업로드 된 이미지 URL 저장
//         BigInfoProvider.roomImage = _uploadedImageUrl;
//       });
//       if (kDebugMode) {
//         print('이미지 업로드 성공\n');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('이미지 업로드 실패: $e');
//       }
//     }
//   }
// }

// String _getDropdownText(int? value) {
//   switch (value) {
//     case 1:
//       return '빨래';
//     case 2:
//       return '밥먹기';
//     case 3:
//       return '설거지하기';
//     default:
//       return '미션을 선택해주세요';
//   }
// }
