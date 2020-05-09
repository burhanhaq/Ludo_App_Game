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
    return SafeArea(
      child: Container(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
            SizedBox(height: 50),
            Dice(size: 100),
          ],
        ),
      ),
    );
  }
}

class Dice extends StatelessWidget {
  double size;

  Dice({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(size / 9)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: size / 10,
            right: size / 10,
            child: Icon(
              Icons.fiber_manual_record,
              color: red1,
              size: size / 3,
            ),
          ),
          Positioned(
            bottom: size / 10,
            left: size / 10,
            child: Icon(
              Icons.fiber_manual_record,
              color: red1,
              size: size / 3,
            ),
          ),
        ],
      ),
    );
  }
}
