import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'game_state.dart';
import 'column_area.dart';
import 'player_piece.dart';

class PieceHome extends StatefulWidget {
  final PieceType pt;
  var c;

  PieceHome([this.pt]) {
    switch (pt) {
      case PieceType.Green:
        c = green;
        break;
      case PieceType.Blue:
        c = blue;
        break;
      case PieceType.Red:
        c = red1;
        break;
      case PieceType.Yellow:
        c = yellow;
        break;
    }
  }

  @override
  _PieceHomeState createState() => _PieceHomeState();
}

class _PieceHomeState extends State<PieceHome> {
//  bool called = false;
  int diceNum = 0;
//  PlayerPiece p;

  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context);
    List<PlayerPiece> piecesList = [];
    switch (widget.pt) {
      case PieceType.Green:
        gameState.greenPlayerPieces.forEach((element) {
          if (element.location == 0) piecesList.add(element);
        });
        break;
      case PieceType.Blue:
        gameState.bluePlayerPieces.forEach((element) {
          if (element.location == 0) piecesList.add(element);
        });
        break;
      case PieceType.Red:
        gameState.redPlayerPieces.forEach((element) {
          if (element.location == 0) piecesList.add(element);
        });
        break;
      case PieceType.Yellow:
        gameState.yellowPlayerPieces.forEach((element) {
          if (element.location == 0) piecesList.add(element);
        });
        break;
    }
    List<Widget> widgetPieceList = List.generate(
      piecesList.length,
      (index) => GestureDetector(
//        onTap: () => gameState.pieceTap(piecesList[index]),
        child: Container(
          margin: const EdgeInsets.all(7.0),
          child: piecesList[index].container,
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        setState(() {
//          diceNum = gameState.throwDice();
//          if (!called) {
//            p = gameState.addPiece(widget.pt);
//            called = true;
//          }
//          gameState.movePiece(p, diceNum);
//          gameState.canDelete(p.location);
        });
      },
      child: Container(
        height: kHomeWidth,
        width: kHomeWidth,
        decoration: BoxDecoration(
          color: gameState.getTurn() == widget.pt ? trans : widget.c,
          boxShadow: [
            BoxShadow(
              color: white,
            ),
            BoxShadow(
              color: widget.c,
              blurRadius: 15,
              spreadRadius: -10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: widgetPieceList,
            ),
          ],
        ),
      ),
    );
  }
}
