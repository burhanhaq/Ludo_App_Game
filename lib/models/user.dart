import 'package:flutter/material.dart';
import 'package:ludo_app/fire_helper.dart';

class User {
  String userID;
  String name;
  int wins;
  int games;

  User({
    @required this.userID,
    @required this.name,
    this.wins = 0,
    this.games = 0,
  });

  Map<String, dynamic> toJson() => {
        Fire.USER_ID: userID,
        Fire.NAME: name,
        Fire.WINS: wins,
        Fire.GAMES: games,
      };

  User.fromJson(Map<String, dynamic> json)
      : userID = json[Fire.USER_ID],
        name = json[Fire.NAME],
        wins = json[Fire.WINS],
        games = json[Fire.GAMES];
}
