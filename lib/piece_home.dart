import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'game_state.dart';
import 'player_piece.dart';

class PieceHome extends StatefulWidget {
  final PieceType pt;
  var c;

  PieceHome([this.pt]) {
    c = PlayerPiece.getColor(this.pt);
  }

  @override
  _PieceHomeState createState() => _PieceHomeState();
}

class _PieceHomeState extends State<PieceHome> {
  int diceNum = 0;

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
    for (int i = 0; i < 4 - piecesList.length; i++) {
      piecesList.add(null);
    }
    List<Widget> widgetPieceList = List.generate(
      piecesList.length,
      (index) => GestureDetector(
        onTap: () => gameState.pieceTap(piecesList[0]),
        child: Container(
          height: kPieceSize - 5,
          width: kPieceSize - 5,
          decoration: BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle,
          ),
          child: Container(
            margin: const EdgeInsets.all(7.0),
            child: piecesList[index] == null ? null : piecesList[index].container,
          ),
        ),
      ),
    );
    return Container(
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
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
//        childAspectRatio: 2,
        padding: EdgeInsets.all(30),
        children: widgetPieceList,
      ),
    );
  }
}
