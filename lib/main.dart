import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_state.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => GameState()..initialize(),
        child: Home(),
      ),
    );
  }
}
