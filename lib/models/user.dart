import 'package:flutter/material.dart';
import 'package:ludo_app/fire_helper.dart';

class User {
  String name;
  int wins;
  int games;

  User({
    @required this.name,
    this.wins = 0,
    this.games = 0,
  });

  Map<String, dynamic> toJson() => {
        Fire.NAME: name,
        Fire.WINS: wins,
        Fire.GAMES: games,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = json[Fire.NAME],
        wins = json[Fire.WINS],
        games = json[Fire.GAMES];

  @override
  bool operator ==(other) {
    if (other is! User) return false;
    User otherUser = other;
    return this.name.toLowerCase() == otherUser.name.toLowerCase();
  }

  @override
  int get hashCode => this.name.toLowerCase().hashCode;

  static String h(String username) {
    return username.toLowerCase().hashCode.toString();
  }

  @override
  String toString() {
    return '$hashCode $name $wins/$games';
  }

}
