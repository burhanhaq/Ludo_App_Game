import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_state.dart';
import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisIsLudo',
      home: ChangeNotifierProvider(
        create: (context) => GameState(),
        child: Home(),
      ),
    );
  }
}
