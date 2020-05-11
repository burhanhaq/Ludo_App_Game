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
        top: value,
        child: IgnorePointer(
          child: widget.slot.playerPieceList[index].container,
        ),
      );
    });
    if (playerPieceListWidget.isNotEmpty) {
      print('PlayerPieceList --------------------------------');
      print(widget.slot.playerPieceList);
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    }
    List<Widget> stackList = [textWidget] + playerPieceListWidget;
//    print('StackList --------------------------------');
//    print(stackList);
    PieceType turn = gameState.getTurn();
    bool containsPiece =
        widget.slot.playerPieceList.any((element) => element.pieceType == turn);
    PlayerPiece pp;
    if (containsPiece) {
      print('AllPlayerPieceLists on slot --------------------------------');
      print(widget.slot.playerPieceList);
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      pp = widget.slot.playerPieceList
          .firstWhere((element) => element.pieceType == turn);
    }
    return GestureDetector(
      onTap: () => gameState.pieceTap(pp),
      child: Container(
//        margin: const EdgeInsets.all(1.0),
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
