import 'package:battleship/view/game_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BattleshipApp());
}

class BattleshipApp extends StatelessWidget {
  const BattleshipApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battleship',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battleship'),
        ),
        body: GameView(),
      ),
    );
  }
}
