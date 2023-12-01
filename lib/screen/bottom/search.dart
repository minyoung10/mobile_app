// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: Column(children: [
        Container(
            margin: EdgeInsets.only(left: 25, top: 76),
            child: Row(children: [
              Text(
                '나의 검색',
                style: blackw500.copyWith(fontSize: 16),
              )
            ])),
        SizedBox(
          height: 225,
        ),
        Container(
            margin: EdgeInsets.only(right: 25),
            child: Column(
              children: [
                Text(
                  '검색 기능은',
                  style: blackw500.copyWith(fontSize: 17),
                ),
                SizedBox(height: 5),
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
