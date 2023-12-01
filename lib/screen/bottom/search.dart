import 'package:flutter/material.dart';

import '../../themepage/theme.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: Column(children: [
        Container(
            margin: const EdgeInsets.only(left: 25, top: 76),
            child: Row(children: [
              Text(
                '나의 검색',
                style: blackw500.copyWith(fontSize: 16),
              )
            ])),
        const SizedBox(
          height: 225,
        ),
        Container(
            margin: const EdgeInsets.only(right: 25),
            child: Column(
              children: [
                Text(
                  '검색 기능은',
                  style: blackw500.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 5),
                Text(
                  '업데이트 예정이에요!',
                  style: blackw500.copyWith(fontSize: 17),
                ),
              ],
            ))
      ]),
    );
  }
}
