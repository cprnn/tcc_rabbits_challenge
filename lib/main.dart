import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

void main() async{  //wait to load all the components (controls) and the game in physical devices
  //print("load the widgets!");
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  RabbitsChallenge game = RabbitsChallenge();
  runApp(GameWidget(game: kDebugMode ? RabbitsChallenge() : game)); //TODO: Remove kdebugmode when release, game : game
}
