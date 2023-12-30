import 'package:flutter/material.dart';
import 'package:flutter_snake/app/game_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Snake Game",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: "Monocraft",
      ),
      home: const GamePage(),
    );
  }
}
