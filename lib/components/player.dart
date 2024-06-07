import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

enum PlayerState {
  //TODO: add more player states
  idle,
  running,
  doubleJump,
  fall,
  jump,
  wallJump
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<RabbitsChallenge>, KeyboardHandler {
  //TODO:after add blockly, remove keyboard controls
  String character;
  //constructor
  Player({position, this.character = 'Ninja Frog'})
      : super(
            position:
                position); //super extends the SpriteAnimationGroupComponent

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation fallAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation wallJumpAnimation;

//Frame animation time
  final double stepTime = 0.05;

//Controls the direction of the movement of the player
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    //dt: delta time
    _updatePlayerState();
    _updatePlayerPosition(dt);
    super.update(dt);
  }

//player movement -> change this to react with Blockly commands
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

//TODO: change the image to the bunny animation
  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    doubleJumpAnimation = _spriteAnimation('Double Jump', 6);
    fallAnimation = _spriteAnimation('Fall', 1);
    jumpAnimation = _spriteAnimation('Jump', 1);
    wallJumpAnimation = _spriteAnimation('Wall Jump', 5);

    animations = {
      //list of animations, add more as implemented
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.doubleJump: doubleJumpAnimation,
      PlayerState.fall: fallAnimation,
      PlayerState.jump: jumpAnimation,
      PlayerState.wallJump: wallJumpAnimation,
    };

//set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    //If moving, set running animation
    if(velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  void _updatePlayerPosition(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
}
