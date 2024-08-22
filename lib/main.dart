/*import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

void main() async{  //wait to load all the components (controls) and the game in physical devices
  //print("load the widgets!");
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  RabbitsChallenge game = RabbitsChallenge();
  runApp(GameWidget(game: kDebugMode ? RabbitsChallenge() : game)); //TODO: Remove kdebugmode when release, game : game
}
*/

import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  RabbitsChallenge game = RabbitsChallenge();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 480, // Set the width of the game
              child: GameWidget(game: game),
            ),
            Expanded(
              child: Container(
                color: const Color(0x253A5633),
                child: const Center(
                  child: Text('Content on the right'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}