import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

void main() {
  //print("load the widgets!");
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  RabbitsChallenge game = RabbitsChallenge();
  runApp(GameWidget(game: kDebugMode ? RabbitsChallenge() : game)); //TODO: Remove kdebugmode when release, game : game
}
