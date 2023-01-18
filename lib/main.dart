import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/zone.dart';
import 'package:battleship/view/battlefield_grid_view.dart';
import 'package:battleship/view/battlefield_view.dart';
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
    final b = BattleField.build(
      Zone(10, 10, 'A'.runes.first, 1),
    );
    b.makeMove(Coordinates('A'.runes.first, 2));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BattleFieldGridView(battleField: b, showShips: false),
    );
  }
}
