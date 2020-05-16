import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'constants.dart';

class Fire {
  static const GAMES_COLLECTION = 'games';
  static const ROOMS_COLLECTION = 'rooms';
  static const USERS_COLLECTION = 'users';

  static const NAME = 'name';
  static const USER_ID = 'userID';
  static const GAMES = 'games';
  static const WINS = 'wins';
  static const ROOM_ID = 'roomID';
  static const GAME_ID = 'gameID';
  static const PLAYER_IDS = 'playerIDs';
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
    addLossToUser('1589372580534');
  }

  createUser(String username) async {
    var userID = DateTime.now().millisecondsSinceEpoch.toString();
    userCollection.document(userID).setData({
      NAME: username,
      USER_ID: userID,
      GAMES: 0,
      WINS: 0,
    }).catchError((error) => null);
    return userID;
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

  getUsers() async {
    List userList = [];
    await userCollection.getDocuments().then((value) {
      value.documents.forEach((element) {
        userList.add(element.data);
      });
    });
    return userList;
  }

  createRoom(String roomname) async {
    var roomID = DateTime.now().millisecondsSinceEpoch.toString();
    await roomCollection.document(roomID).setData({
      NAME: roomname,
      ROOM_ID: roomID,
      GAME_ID: '0',
      PLAYER_IDS: [],
    }).catchError((error) => null);
    return roomID;
  }

  getRooms() async {
    var doc = await roomCollection.getDocuments();
    return doc.documents;
  }

  addUserToRoom(String userID, String roomID) async {
    var doc = roomCollection.document(roomID);
    doc.updateData({
      PLAYER_IDS: FieldValue.arrayUnion([userID]),
    });
  }

  removeUserFromRoom(String userID, String roomID) {
    var doc = roomCollection.document(roomID);
    doc.updateData({
      PLAYER_IDS: FieldValue.arrayRemove([userID]),
    });
  }

  createGame(String roomID) async {
    var diceMovesList = '';
    var locationList = ['0,0,0,0', '0,0,0,0', '0,0,0,0', '0,0,0,0'];
    var turn = 0;
    var playerIDs = [];
    await Firestore.instance
        .collection(ROOMS_COLLECTION)
        .document(roomID)
        .get()
        .then((value) {
      playerIDs = value.data[PLAYER_IDS];
    });
    var gameID = DateTime.now().millisecondsSinceEpoch.toString();
    gameCollection.document(gameID).setData({
      GAME_ID: gameID,
      MOVES_LIST: diceMovesList,
      LOCATION_LIST: locationList,
      ROOM_ID: roomID,
      PLAYER_IDS: playerIDs,
      TURN: turn,
    }).catchError((error) => null);
    addGameIDToRoom(gameID, roomID);
    return gameID;
  }

  addGameIDToRoom(String gameID, String roomID) {
    roomCollection.document(roomID).updateData({
      GAME_ID: roomID,
    }).catchError((error) => null);
    return 1;
  }

  updateFireState(gameID, movesList, locationList, turn) {
    gameCollection.document(gameID).updateData({
      MOVES_LIST: movesList,
      LOCATION_LIST: locationList,
      TURN: turn,
    }).catchError((error) => null);
  }

//  getFireState() {}

  Stream<QuerySnapshot> get roomQuery {
    return roomCollection.snapshots();
  }

  Stream<QuerySnapshot> get userQuery {
    return userCollection.snapshots();
  }

  Stream<DocumentSnapshot> gameStream(String gameID) {
    return gameCollection.document(gameID).snapshots();
  }

  // ignore: close_sinks
  StreamController<List<dynamic>> locationController =
      StreamController<List<dynamic>>.broadcast();
  StreamController<Map<String, dynamic>> everythingController =
      StreamController<Map<String, dynamic>>.broadcast();

//  Stream listenForNewLocation() { // Queryies all
//    gameCollection.snapshots().listen((snapshot) {
//      if (snapshot.documents.isNotEmpty) {
//        var locationListThing = snapshot.documents.map((snap) => snap.data['location_array']).toList();
//        controller.add(locationListThing);
//      }
//    });
//    return controller.stream;
//  }

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
        everythingController.add(locationListThing);
      }
    });
    return everythingController.stream;
  }

  deleteRoom() {}

  deleteGame() {}
}
