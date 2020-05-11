import 'package:flutter/material.dart';
import 'package:ludo_app/column_area.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'piece_home.dart';
import 'game_state.dart';
import 'dice.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context);
    Color stateColor = GameState.getColor(gameState.getTurn());
    List<Widget> diceMovesList = List.generate(
      gameState.movesList.length,
      (index) => Dice(
        size: kSmallDiceSize,
        c: stateColor,
        num: gameState.movesList[index],
      ),
    );
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                SizedBox(
                  width: kBoxWidth * 3 + 4,
                ),
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
            SizedBox(height: 20),
            SizedBox(
              height: kSmallDiceSize,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: diceMovesList,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: gameState.diceTap,
              child: Dice(size: 100, c: stateColor),
            ),
          ],
        ),
      ),
    );
  }
}
