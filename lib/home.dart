import 'package:flutter/gestures.dart';
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
        color: grey,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (kBoxWidth) * 15,
            maxWidth: (kBoxWidth) * 15,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              SizedBox(
                height: (kBoxWidth+2) * 15,
                width: (kBoxWidth+2) * 15,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: PieceHome(PieceType.Blue),
                    ),
                    Positioned(
                      top: 0,
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: ColumnArea(piece: PieceType.Red),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: PieceHome(PieceType.Red),
                    ),
                    Positioned(
                      left: 0,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: ColumnArea(piece: PieceType.Blue),
                      ),
                    ),
                    SizedBox(
//                      width: kBoxWidth * 3 + 4,
//                      height: kBoxWidth * 3 + 4,
                    ),
                    Positioned(
                      right: 0,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: ColumnArea(piece: PieceType.Yellow),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: PieceHome(PieceType.Green),
                    ),
                    Positioned(
                      bottom: 0,
                      child: RotatedBox(
                        quarterTurns: 0,
                        child: ColumnArea(piece: PieceType.Green),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: PieceHome(PieceType.Yellow),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
