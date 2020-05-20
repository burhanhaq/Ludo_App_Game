import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/player_piece.dart';
import '../../constants.dart';
import '../../widgets/piece_home.dart';
import '../../game_state.dart';
import '../../helper/fire_helper.dart';
import '../../models/user.dart';

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    double width = MediaQuery.of(context).size.width * kPageOpenWidthMultiplier;
    double height = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top) *
        kHeightMultiplier;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < width) return Center();
        return Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  gameState.pageForward(PageOption.CreateUsername);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Create Username', style: kPageContentStyle),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black45,
                      size: 80,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  gameState.pageForward(PageOption.SignIn);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Sign In', style: kPageContentStyle, maxLines: 3),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black45,
                      size: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

