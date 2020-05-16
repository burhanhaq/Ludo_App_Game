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
    List<PlayerPiece> piecesList = gameState.getPlayerPieceList(widget.pt);
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
            child: piecesList[index].isAtHome()
                ? piecesList[index].container
                : null,
          ),
        ),
      ),
    );
    Icon iconWidget = Icon(Icons.signal_cellular_off,
        color: gameState.getTurn() == widget.pt ? Colors.black54 : trans,
        size: kHomeWidth / 5);
    return Container(
      height: kHomeWidth,
      width: kHomeWidth,
      decoration: BoxDecoration(
        color: widget.c,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
//        border: Border.all(), // todo all cool border color
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            padding: EdgeInsets.all(30),
            children: widgetPieceList,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: RotatedBox(quarterTurns: 2, child: iconWidget),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: RotatedBox(quarterTurns: 3, child: iconWidget),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: RotatedBox(quarterTurns: 1, child: iconWidget),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: RotatedBox(quarterTurns: 0, child: iconWidget),
          ),
        ],
      ),
    );
  }
}
