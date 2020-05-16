import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'piece_home.dart';
import 'game_state.dart';
import 'fire_helper.dart';

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

class PageTwo extends StatelessWidget {
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
                Text('Create Username', style: kPageContentStyle),
                // todo add sign in thingy too
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField()),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    gameState.pageForward(PageOption.None);
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

class PageThree extends StatelessWidget {
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
                  gameState.pageForward(PageOption.CreateRoom);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Create Room', style: kPageContentStyle),
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
                  gameState.pageForward(PageOption.JoinRoom);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Join Room', style: kPageContentStyle, maxLines: 3),
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

class PageFour extends StatelessWidget {
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
              Text('Room Create or Join', style: kPageContentStyle),
              Spacer(),
              GestureDetector(
                onTap: () {
                  gameState.pageForward(PageOption.StartGame);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Start Game',
                        style: kPageContentStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
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
