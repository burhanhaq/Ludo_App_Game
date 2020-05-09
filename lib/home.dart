import 'package:flutter/material.dart';
import 'package:ludo_app/column_area.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'piece_home.dart';
import 'game_state.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              PieceHome(PieceType.Blue),
              RotatedBox(
                quarterTurns: 2,
                child: ColumnArea(piece: PieceType.Red),
              ),
              PieceHome(PieceType.Red),
            ],
          ),
          Row(
            children: <Widget>[
              RotatedBox(
                quarterTurns: 1,
                child: ColumnArea(piece: PieceType.Blue),
              ),
              Spacer(),
              RotatedBox(
                quarterTurns: -1,
                child: ColumnArea(piece: PieceType.Yellow),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              PieceHome(PieceType.Green),
              RotatedBox(
                quarterTurns: 0,
                child: ColumnArea(piece: PieceType.Green),
              ),
              PieceHome(PieceType.Yellow),
            ],
          ),
        ],
      ),
    );
  }
}
