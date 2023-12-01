import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screen/account/login.dart';
import 'screen/bottom/bottom.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Fistpage());
}

class Fistpage extends StatelessWidget {
  const Fistpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color.fromRGBO(54, 209, 0, 1)),
      initialRoute: '/login',
      routes: {
        '/': (BuildContext context) => const BottomNavigation(),
        '/login': (BuildContext context) => const LoginPage(),
      },
    );
  }
}
