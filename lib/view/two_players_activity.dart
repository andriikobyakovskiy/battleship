import 'package:battleship/view/awaiting_player_screen.dart';
import 'package:flutter/material.dart';

typedef WidgetBuilder = Widget Function(
  Function resume,
  Function(String) onError,
  Function(String) onSwitch
);

class TwoPlayersActivity extends StatefulWidget {
  final WidgetBuilder battleWidgetBuilder;
  final Function resume;
  final String header;
  final String firstPlayer;

  const TwoPlayersActivity({
    super.key,
    required this.battleWidgetBuilder,
    required this.resume,
    required this.header,
    required this.firstPlayer,
  });

  @override
  State createState() => _TwoPlayersActivityState();
}

class _TwoPlayersActivityState extends State<TwoPlayersActivity> {
  bool _currentPlayerReady = false;
  String _error = '';
  late String _currentPlayer;

  @override
  void initState() {
    super.initState();
    _currentPlayer = widget.firstPlayer;
  }

  @override
  Widget build(BuildContext context) {
    if (!_currentPlayerReady) {
      return AwaitingPlayerScreen(
        onReady: () => setState(() {
          _currentPlayerReady = true;
        }),
        player: _currentPlayer,
      );
    }
    return Column(
      children: [
        Text(widget.header, style: const TextStyle(fontSize: 24)),
        Text(_error, style: const TextStyle(fontSize: 12, color: Colors.red)),
        widget.battleWidgetBuilder(
          widget.resume,
          (error) => setState(() { _error = error; }),
          (nextPlayer) => setState(() {
            _currentPlayer = nextPlayer;
            _currentPlayerReady = false;
          }),
        )
      ]
    );
  }
}