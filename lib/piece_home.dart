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
  bool called = false;
  int diceNum = 0;
  PlayerPiece p;

  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context);
    List<PlayerPiece> piecesList;
    switch (widget.pt) {
      case PieceType.Green:
        piecesList = gameState.greenPlayerPieces;
        break;
      case PieceType.Blue:
        piecesList = gameState.bluePlayerPieces;
        break;
      case PieceType.Red:
        piecesList = gameState.redPlayerPieces;
        break;
      case PieceType.Yellow:
        piecesList = gameState.yellowPlayerPieces;
        break;
    }
    List<Widget> widgetPieceList =
        List.generate(piecesList.length, (index) => piecesList[0].container);
    return GestureDetector(
      onTap: () {
        setState(() {
          diceNum = gameState.throwDice();
          if (!called) {
            p = gameState.addPiece(widget.pt);
            called = true;
          }
          gameState.movePiece(p, diceNum);
          gameState.canDelete(p, p.location);
        });
      },
      child: Container(
        height: homeWidth,
        width: homeWidth,
        color: widget.c,
        child: Column(
          children: <Widget>[
            Text('diceNum: $diceNum', style: kStyle),
            Column(
              children: widgetPieceList,
            ),
          ],
        ),
      ),
    );
  }
}
