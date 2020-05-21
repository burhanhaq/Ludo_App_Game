import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/player_piece.dart';
import '../../constants.dart';
import '../../widgets/piece_home.dart';
import '../../game_state.dart';
import '../../helper/fire_helper.dart';
import '../../models/user.dart';

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  String supportText = '';

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

        return Material(
          color: trans,
          child: Container(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    gameState.curPageOption == PageOption.CreateUsername
                        ? 'Create Username'
                        : 'Sign In',
                    style: kPageContentStyle),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Username'),
                      onChanged: (val) {
                        gameState.userName = val;
                      },
                      maxLength: 10,
                    )),
                Text(supportText,
                    style: kPageContentStyle.copyWith(fontSize: 15)),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () async {
                    gameState.user = null;
                    if (gameState.userName == null || gameState.userName == '')
                      return;
                    gameState.user =
                        await Fire.instance.doesUserExist(gameState.userName);
                    setState(() {
                      if (gameState.curPageOption ==
                          PageOption.CreateUsername) {
                        if (gameState.user == null) {
                          // good
                          supportText =
                              'Created new user ${gameState.userName}';
                          gameState.user = User(name: gameState.userName);
                          Fire.instance.createUser(gameState.user);
                        } else {
                          // bad
                          supportText = 'User already Exists, please sign in';
                        }
                      } else if (gameState.curPageOption == PageOption.SignIn) {
                        if (gameState.user == null) {
                          // bad
                          supportText =
                              'User ${gameState.userName} doesn\'t exist, please create account';
                        } else {
                          // good
                          supportText = 'Signing in ${gameState.userName}';
                        }
                      }
                    });
                    if (gameState.user != null) {
                      print(gameState.user);
                      gameState.userName = '';
                      gameState.pageForward(PageOption.None);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
          ),
        );
      },
    );
  }
}
