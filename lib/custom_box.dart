import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'game_state.dart';
import 'slot.dart';

class CustomBox extends StatefulWidget {
  Slot slot;
  final Color c;

  CustomBox(this.slot, {this.c = white});

  @override
  _CustomBoxState createState() => _CustomBoxState();
}

class _CustomBoxState extends State<CustomBox> {

  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    var text = widget.slot.id.toString();
    if (widget.slot.isStop) {
      text = 'S';
    } else if (widget.slot.isEnd) {
      text = 'E';
    }

    text = '';
    Widget textWidget = Text(
      text,
      style: TextStyle(
        color: Colors.brown,
        fontSize: 17,
        decoration: TextDecoration.none,
      ),
    );
    var value = 0.0;
    List<Widget> playerPieceListWidget =
        List.generate(widget.slot.playerPieceList.length, (index) {
          value += 4.0;
      return Positioned(
          top: value, child: widget.slot.playerPieceList[index].container);
    });
    List<Widget> stackList = [textWidget] + playerPieceListWidget;
    return Container(
      margin: const EdgeInsets.all(1.0),
      color: widget.c,
      child: SizedBox(
        height: boxWidth,
        width: boxWidth,
        child: Stack(
          alignment: Alignment.center,
          children: stackList,
        ),
      ),
    );
  }
}
