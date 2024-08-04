import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:tcc_rabbits_challenge/components/player.dart';
import 'package:tcc_rabbits_challenge/components/level.dart';

class RabbitsChallenge extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  //TODO: change to blockly handler
 
 
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Smoke');
  late JoystickComponent joystick;
  bool showJoystick = false;
  bool playSounds = false; //TODO: turn it off when coding if debugging in Windows
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-02',
    'Level-02', //TODO: add here all the levels
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    //loading all images to cache
    await images
        .loadAllImages(); // TODO: change this to loadAll and specify wich images load

    _loadLevel();

    if (showJoystick) {
      addJoystick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }


//Functions that control the level system, add loading screens and control access by the
//home buttons and between levels, on a loading/continue screen

  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //no more levels TODO: make it go to home screen, not the first level
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () { //TODO: on this delay, add a loading screen
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 480,
        height: 864,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
