import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tcc_rabbits_challenge/levels/level.dart';

class RabbitsChallenge extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  @override
  final world = Level(levelName: 'Level-01');

  @override
  FutureOr<void> onLoad() async {
    //loading all images to cache
    await images
        .loadAllImages(); // TODO: change this to load all and specify wich images load

    cam = CameraComponent.withFixedResolution(
        world: world, width: 480, height: 864);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    return super.onLoad();
  }
}
