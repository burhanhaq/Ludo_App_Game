import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'game_state.dart';
import 'slot.dart';
import 'player_piece.dart';

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
    List<PlayerPiece> piecesList = widget.slot.playerPieceList;
    var text = widget.slot.id.toString();
    if (!kDebugMode || widget.slot.isStop()) {
      text = '';
    }
    Widget textWidget = Text(
      text,
      style: TextStyle(
        color: Colors.brown,
        fontSize: 17,
        decoration: TextDecoration.none,
      ),
    );
    List<Widget> playerPieceListWidget = [];
    if (piecesList.length == 1) {
      playerPieceListWidget.add(IgnorePointer(child: piecesList[0].container));
    } else {
      var offsetValue = -4.0;
      playerPieceListWidget = List.generate(piecesList.length, (index) {
        offsetValue += 4.0; // todo lol this
        return Positioned(
          top: offsetValue,
          child: IgnorePointer(
            child: piecesList[index].container,
          ),
        );
      });
    }

    List<Widget> stackList = [textWidget] + playerPieceListWidget;
    if (widget.slot.isHomeStop) {
      stackList.insert(
          0,
          Icon(
            Icons.merge_type,
            color: Colors.black45,
            size: kBoxWidth,
          ));
    } else if (widget.slot.isOtherStop) {
      stackList.insert(
          0,
          RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.call_split,
              color: Colors.black45,
              size: kBoxWidth,
            ),
          ));
    }
    PieceType turn = gameState.getTurn();
    bool containsPiece = piecesList.any((element) => element.pieceType == turn);
    PlayerPiece pp;
    if (containsPiece) {
      pp = piecesList.firstWhere((element) => element.pieceType == turn);
    }
    return GestureDetector(
      onTap: () => gameState.pieceTap(pp),
      child: Container(
        decoration: BoxDecoration(
          color: widget.c,
          border: Border.all(color: Colors.black, width: kBoxBorderWidth),
        ),
        child: SizedBox(
          height: kBoxWidth,
          width: kBoxWidth,
          child: Stack(
            alignment: Alignment.center,
            children: stackList,
          ),
        ),
      ),
    );
  }
}
