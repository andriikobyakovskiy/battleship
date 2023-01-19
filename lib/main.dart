import 'package:battleship/controller/battle_controller.dart';
import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/ship.dart';
import 'package:battleship/model/zone.dart';
import 'package:battleship/view/battle_view.dart';
import 'package:battleship/view/two_players_activity.dart';
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
    final b1 = BattleField.build(
      Zone(10, 10, 'A'.runes.first, 1),
      existingShips: [
        Ship.build(
          Coordinates.letterDigit('E', 6),
          Coordinates.letterDigit('G', 6),
        ),
      ]
    );
    final b2 = BattleField.build(
      Zone(10, 10, 'A'.runes.first, 1),
      existingShips: [
        Ship.build(
          Coordinates.letterDigit('E', 2),
          Coordinates.letterDigit('G', 2),
        ),
      ]
    );
    final controller = BattleController.initiate({"Player1": b1, "Player2": b2});
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TwoPlayersActivity(
        resume: (winner) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$winner is a winner!"),
          ));
        },
        header: "Demo Battleship",
        firstPlayer: controller.currentPlayer,
        battleWidgetBuilder: (resume, onError, onSwitch) => BattleView(
          battleController: controller,
          onError: onError,
          onSwitch: onSwitch,
          onVictory: (w) {
            onError('');
            resume(w);
          },
        ),
      ),
    );
  }
}
