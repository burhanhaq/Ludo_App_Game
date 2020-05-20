import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../../models/player_piece.dart';
import '../../constants.dart';
import '../../widgets/piece_home.dart';
import '../../game_state.dart';
import '../../helper/fire_helper.dart';
import '../../models/user.dart';

class PageFour extends StatefulWidget {
  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  var supportText = '';

  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    double width = MediaQuery.of(context).size.width * kPageOpenWidthMultiplier;
    double height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) *
        kHeightMultiplier;

    var createRoomWidget = Column(
      children: <Widget>[
        Text('Create Room', style: kPageContentStyle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: TextField(
            decoration: InputDecoration(hintText: 'Room Name'),
            onChanged: (val) {
              gameState.roomName = val;
            },
            maxLength: 10,
          ),
        ),
        Text(supportText, style: kPageContentStyle.copyWith(fontSize: 15)),
        GestureDetector(
          onTap: () async {
            Future future = Fire.instance.doesRoomExist(gameState.roomName);
            setState(() {
              future.then((roomExists) async {
                if (roomExists) {
                  // bad
                  supportText =
                      'Room already exists. Either enter another room name to create or join the existing room.';
                } else {
                  // good
                  await Fire.instance.createRoom(gameState.roomName);
//                  await Fire.instance.addUserToRoom(
//                      kHash(gameState.userName), kHash(gameState.roomName));
                  supportText = 'Creating room ${gameState.roomName}';
                  gameState.pageForward(PageOption.JoinRoom);
                }
              });
            });
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
    );
    var joinRoomWidget = Column(
      children: <Widget>[
        Text('Join Room', style: kPageContentStyle),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Room Name',
                      style: kPageContentStyle.copyWith(fontSize: 15)),
                  Spacer(),
                  Text('Players in Room',
                      style: kPageContentStyle.copyWith(fontSize: 15)),
                ],
              ),
              Container(
                color: yellow2,
                height: 400,
                child: StreamBuilder(
                  stream: Fire.instance.roomQuery,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      var roomList = [];
                      snapshot.data.documents.forEach((element) {
                        roomList.add(element.data);
                      });
                      var roomWidgetList =
                          List.generate(roomList.length, (index) {
                        String roomName = roomList[index][Fire.NAME];
                        String numPlayerInRoom = roomList[index]
                                [Fire.PLAYER_NAMES]
                            .length
                            .toString();
                        return GestureDetector(
                          onTap: () {
                            gameState.roomName = roomList[index][Fire.NAME];
                            Fire.instance.addUserToRoom(
                                gameState.user.name, gameState.roomName);
                            gameState.pageForward(PageOption.InsideRoom);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            color: yellow,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  roomName,
                                  style: kPageContentStyle,
                                ),
                                Spacer(),
                                Text(
                                  numPlayerInRoom,
                                  style: kPageContentStyle,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                      return ListView(
                        children: roomWidgetList,
                      );
                    }
                    return Text(
                        'No rooms available. Please create a new room.');
                  },
                ),
              ),
            ],
          ),
        ),
//        GestureDetector(
//          onTap: () {
//            gameState.pageForward(PageOption.InsideRoom);
//          },
//          child: Icon(
//            Icons.arrow_forward,
//            color: Colors.black45,
//            size: 80,
//          ),
//        ),
      ],
    );
    Stream<DocumentSnapshot> roomStream =
        Fire.instance.roomStream(gameState.roomName);
    StreamSubscription roomSubscription =
        roomStream.listen((DocumentSnapshot event) {
      if (event.exists) {
        List<dynamic> playerNameList = event.data[Fire.PLAYER_NAMES];
        var gameID = event.data[Fire.GAME_ID];
        if (gameID.toString().length > 0) {
          if (gameState.gameID == null) {
            gameState.gameID = event.data[Fire.GAME_ID];
            gameState.pageForward(PageOption.StartGame);
            print('ID: >>> ${gameState.gameID}');
          }
        }

        if (!listEquals(gameState.playerNameList, playerNameList)) {
          gameState.playerNameList = playerNameList;
          var usernameIndex =
              gameState.playerNameList.indexOf(gameState.user.name);
          if (usernameIndex >= 0) {
            gameState.curPlayerPieceType =
                gameState.initialPlayerPieceTypeFormation[usernameIndex];
          }
        }
      }
    });
    var insideRoomWidget = Column(
      children: <Widget>[
        StreamBuilder(
          // todo do we need stream builder
          stream: roomStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              String roomName = gameState.roomName;

              List<Widget> columnList = List.generate(
                gameState.playerNameList.length,
                (index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 50),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: PlayerPiece.getColor(
                          gameState.initialPlayerPieceTypeFormation[index],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      gameState.playerNameList[index],
                      style: kPageFourStyle,
                    ),
                  ],
                ),
              );
              columnList.insert(
                  0,
                  Divider(
                    color: white,
                    indent: 20,
                    endIndent: 20,
                  ));
              columnList.insert(0, Text(roomName, style: kPageFourStyle));
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                color: Colors.grey[500],
                height: 200,
                width: double.infinity,
                child: Column(
                  children: columnList,
                ),
              );
            }
            return Text('Loading');
          },
        ),
        SizedBox(height: 40),
        GestureDetector(
          onTap: () async {
            roomSubscription.cancel();
            gameState.gameID =
                await Fire.instance.createGame(gameState.roomName);
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
    );

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
                LayoutBuilder(
                  builder: (context, constraints) {
                    switch (gameState.curPageOption) {
                      case PageOption.CreateRoom:
                        return createRoomWidget;
                      case PageOption.JoinRoom:
                        return joinRoomWidget;
                      case PageOption.InsideRoom:
                        return insideRoomWidget;
                      default:
                        return Center();
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
//    xxx.cancel();
    super.dispose();
  }
}
