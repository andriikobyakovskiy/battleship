import 'package:battleship/model/battlefield.dart';

String otherPlayer(
  String currentPlayer,
  Map<String, BattleField> battleFields
) => battleFields.keys.firstWhere((key) => key != currentPlayer);

BattleField otherBattleField(
  String currentPlayer,
  Map<String, BattleField> battleFields
) => battleFields.entries.firstWhere((e) => e.key != currentPlayer).value;
