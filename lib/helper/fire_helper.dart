import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'dart:io';

import '../constants.dart';
import '../models/user.dart';

class Fire {
  static const GAMES_COLLECTION = 'games';
  static const ROOMS_COLLECTION = 'rooms';
  static const USERS_COLLECTION = 'users';

  static const NAME = 'name';
  static const USER_ID = 'userID';
  static const GAMES = 'games';
  static const WINS = 'wins';
  static const ROOM_ID = 'roomID';
  static const PRIVATE_ROOM = 'privateRoom';
  static const GAME_ID = 'gameID';
  static const PLAYER_NAMES = 'playerNames';
  static const MOVES_LIST = 'movesList';
  static const LOCATION_LIST = 'locationList';
  static const TURN = 'turn';

  Fire._privateConstructor();

  static final Fire instance = Fire._privateConstructor();
  final CollectionReference gameCollection =
      Firestore.instance.collection(GAMES_COLLECTION);
  final CollectionReference userCollection =
      Firestore.instance.collection(USERS_COLLECTION);
  final CollectionReference roomCollection =
      Firestore.instance.collection(ROOMS_COLLECTION);

  run() async {
//    addUserToRoom('1589372580534', '1589372798929');
//    addUserToRoom('1589372580539', '1589372798929');
//    addUserToRoom('1589372580541', '1589372798929');
//    createRoom('room1');
//    createRoom('room2');
//    createRoom('room3');
//    createRoom('room4');
//    createGame('1589372798929');
//    addLossToUser('1589372580534');
//    createUserWithUsername('u1');
//    createUserWithUsername('u2');
//    createUserWithUsername('u3');
//    createUserWithUsername('u4');
//    createUserWithUsername('u5');
//    createUserWithUsername('u6');
//    createUserWithUsername('u7');
  }

  createUser(User user) async {
    var userID = kHash(user.name);
    await userCollection
        .document(userID)
        .setData(user.toJson())
        .catchError((error) => null);
  }

  createUserWithUsername(String username) async {
    var userID = kHash(username);
    User user = User(name: username);
    await userCollection
        .document(userID)
        .setData(user.toJson())
        .catchError((error) => null);
  }

  doesUserExist(String username) async {
    var user;
    await userCollection
        .document(kHash(username))
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) user = User.fromJson(ds.data);
    });
    return await user;
  }

  doesRoomExist(String roomname) async {
    var roomID = kHash(roomname);
    bool exists = false;
    await roomCollection.document(roomID).get().then((DocumentSnapshot ds) {
      if (ds.exists) exists = true;
    });
    return exists;
  }

  addWinToUser(String userID) {
    var doc = userCollection.document(userID);
    doc.updateData({
      WINS: FieldValue.increment(1),
      GAMES: FieldValue.increment(1),
    });
  }

  addLossToUser(String userID) {
    var doc = userCollection.document(userID);
    doc.updateData({
      GAMES: FieldValue.increment(1),
    });
  }

  createRoom(String roomname, {bool private = false}) async {
    var roomID = kHash(roomname);
    await roomCollection.document(roomID).setData({
      NAME: roomname,
      PRIVATE_ROOM: private,
      GAME_ID: '',
      PLAYER_NAMES: [],
    }).catchError((error) => print('Error in createRoom()'));
    return roomID;
  }

//  getRooms() async {
//    var doc = await roomCollection.getDocuments();
//    return doc.documents;
//  }

  // todo don't add more than 4 players
  addUserToRoom(String username, String roomname) async {
    var roomID = kHash(roomname);
    var doc = roomCollection.document(roomID);
    doc.updateData({
      PLAYER_NAMES: FieldValue.arrayUnion([username]),
    });
  }

  removeUserFromRoom(String username, String roomname) {
    var roomID = kHash(roomname);
    var doc = roomCollection.document(roomID);
    doc.updateData({
      PLAYER_NAMES: FieldValue.arrayRemove([username]),
    });
  }

  createGame(String roomname) async {
    var roomID = kHash(roomname);
    var diceMovesList = '';
    var locationList = ['0,0,0,0', '0,0,0,0', '0,0,0,0', '0,0,0,0'];
    var turn = 0;
    var playerNames = [];
    await Firestore.instance
        .collection(ROOMS_COLLECTION)
        .document(roomID)
        .get()
        .then((value) {
      playerNames = value.data[PLAYER_NAMES];
    });
    var gameID = DateTime.now().millisecondsSinceEpoch.toString();
    gameCollection.document(gameID).setData({
      GAME_ID: gameID,
      MOVES_LIST: diceMovesList,
      LOCATION_LIST: locationList,
      ROOM_ID: roomID,
      PLAYER_NAMES: playerNames,
      TURN: turn,
    }).catchError((error) => null);
    _addGameIDToRoom(gameID, roomID);
    return gameID;
  }

  _addGameIDToRoom(String gameID, String roomID) {
    roomCollection.document(roomID).updateData({
      GAME_ID: gameID,
    }).catchError((error) => null);
//    return 1;
  }

  updateFireState(
      String gameID, String movesList, List locationList, PieceType turn) {
    gameCollection.document(gameID).updateData({
      MOVES_LIST: movesList,
      LOCATION_LIST: locationList,
      TURN: turn,
    }).catchError((error) => null);
  }

  updateMovesList(String gameID, String movesList) {
    gameCollection.document(gameID).updateData({
      MOVES_LIST: movesList,
    }).catchError((onError) => print(onError));
  }

  updateLocationList(String gameID, List<String> locationList) {
    gameCollection.document(gameID).updateData({
      LOCATION_LIST: locationList,
    });
  }

  updateTurn(String gameID, PieceType turn) {
    gameCollection.document(gameID).updateData({
      TURN: turn.index,
    });
  }

  Stream<QuerySnapshot> get roomQuery {
    return roomCollection.snapshots();
  }

  Stream<DocumentSnapshot> roomStream(String roomname) {
    var roomID = kHash(roomname);
    return roomCollection.document(roomID).snapshots();
  }

//  Stream<QuerySnapshot> get userQuery {
//    return userCollection.snapshots();
//  }

  Stream<DocumentSnapshot> gameStream(String gameID) {
    return gameCollection.document(gameID).snapshots();
  }

  StreamController<List<dynamic>> locationController =
      StreamController<List<dynamic>>.broadcast();
  StreamController<Map<String, dynamic>> fullGameController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream listenForNewLocation() {
    gameStream('1589373131638').listen((snapshot) {
      if (snapshot.data.isNotEmpty) {
        List<dynamic> locationListThing = snapshot.data[LOCATION_LIST];
        locationController.add(locationListThing);
      }
    });
    return locationController.stream;
  }

  Stream listenForNewEverything() {
    gameStream('1589373131638').listen((snapshot) {
      if (snapshot.data.isNotEmpty) {
        var locationListThing = snapshot.data;
        fullGameController.add(locationListThing);
      }
    });
    return fullGameController.stream;
  }

//  Stream listenForNewLocation() { // Queryies all
//    gameCollection.snapshots().listen((snapshot) {
//      if (snapshot.documents.isNotEmpty) {
//        var locationListThing = snapshot.documents.map((snap) => snap.data['location_array']).toList();
//        controller.add(locationListThing);
//      }
//    });
//    return controller.stream;
//  }
  deleteRoom() {}

  deleteGame() {}

}
