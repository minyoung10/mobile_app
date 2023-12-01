import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecog extends StatefulWidget {
  const TextRecog({Key? key}) : super(key: key);

  @override
  State<TextRecog> createState() => _TextRecogState();
}

class _TextRecogState extends State<TextRecog> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String scannedText = ""; // textRecognizer로 인식된 텍스트를 담을 String
  String needPeople = "";
  String needMoney = "";
  String people = "";
  String money = "";
  bool isMatched = false;
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();

  @override
  void dispose() {
    _peopleController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
      getRecognizedText(_image!); // 이미지를 가져온 뒤 텍스트 인식 실행
    }
  }

  void getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);

    // textRecognizer 초기화, 이때 script에 인식하고자하는 언어를 인자로 넘겨줌
    // ex) 영어는 script: TextRecognitionScript.latin, 한국어는 script: TextRecognitionScript.korean
    final textRecognizer =
        GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.korean);

    // 이미지의 텍스트 인식해서 recognizedText에 저장
    RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Release resources
    await textRecognizer.close();

    // 인식한 텍스트 정보를 scannedText에 저장
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }

    setState(() {
      RegExp peopleExp = RegExp(r"(.*) 님께");
      people = peopleExp.firstMatch(scannedText)!.group(1)!;

// '원' 앞에 있는 숫자를 찾는 정규 표현식
      RegExp moneyExp = RegExp(r"(\d+)원");
      money = moneyExp.firstMatch(scannedText)!.group(1)!;

      debugPrint('people: $people');
      debugPrint('money: $money');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Test")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30, width: double.infinity),
          _buildPhotoArea(),
          TextFormField(
            controller: _peopleController,
            onChanged: (value) {
              setState(() => needPeople = _peopleController.text);
            },
          ),
          TextFormField(
            controller: _moneyController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          _buildRecognizedText(),
          const SizedBox(height: 20),
          _buildButton(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (people == _peopleController.text &&
                  money == _moneyController.text) {
                isMatched = true;
              } else {
                isMatched = false;
              }
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? SizedBox(
            width: 100,
            height: 100,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 100,
            height: 100,
            color: Colors.grey,
          );
  }

  Widget _buildRecognizedText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("받아야 할 입금자 명: ${_peopleController.text}"),
        Text("받아야 할 금액: ${_moneyController.text}"),
        Text("입력된 입금자명: $people"),
        Text("입금된 금액: $money"),
        isMatched ? const Text("일치합니다.") : const Text("일치하지 않습니다."),
      ],
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }
}
