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
    piecesList = gameState.getPlayerPieceList(widget.pt);
    List<Widget> widgetPieceList = List.generate(
      piecesList.length,
      (index) => GestureDetector(
        onTap: () => gameState.pieceTap(piecesList[index]),
        child: Container(
          height: kPieceSize - 5,
          width: kPieceSize - 5,
          decoration: BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle,
          ),
          child: Container(
            margin: const EdgeInsets.all(7.0),
            child:
            piecesList[index].isAtHome() ? piecesList[index].container : null,
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
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
//        border: Border.all(), // todo all cool border color
      ),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        padding: EdgeInsets.all(30),
        children: widgetPieceList,
      ),
    );
  }
}
