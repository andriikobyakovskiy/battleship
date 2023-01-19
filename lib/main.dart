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
      home: const MenuPage(title: 'Menu'),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GameView(),
    );
  }
}
