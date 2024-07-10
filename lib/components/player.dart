import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tcc_rabbits_challenge/components/collision_block.dart';
import 'package:tcc_rabbits_challenge/components/player_hitbox.dart';
import 'package:tcc_rabbits_challenge/components/utils.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

enum PlayerState {
  //TODO: add more player states
  idle,
  running,
  doubleJump,
  falling,
  jumping,
  wallJumping
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<RabbitsChallenge>, KeyboardHandler {
  //TODO:after add blockly, remove keyboard controls
  String character;
  //constructor
  // ignore: use_super_parameters
  Player({position, this.character = 'Ninja Frog'})
      : super(
            position:
                position); //super extends the SpriteAnimationGroupComponent

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation wallJumpAnimation;

//Frame animation time
  final double stepTime = 0.05;

//Gravity and fall controls
  final double _gravity = 9.8;
  final double _jumpForce = 330;
  final double _terminalVelocity = 300;

//Controls the direction of the movement of the player
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

//Checks vertical collision and jump
  bool isOnGround = false;
  bool hasJumped = false;

  List<CollisionBlock> collisionBlocks = [];

  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    //debugMode = true; //TODO: do not forget to remove this andsee if its possible to change to the native hitbox component
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    //dt: delta time
    _updatePlayerState();
    _updatePlayerPosition(dt);

    _checkHorizontalCollisions();
    _applyGravity(dt);

    _checkVerticalCollisions();

    super.update(dt);
  }

//player movement -> TODO: change this to react with Blockly commands
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

//TODO: change the image to the bunny animation
  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
   // idleAnimation = _spriteAnimation('Idle', 4); //add more frames to bunny on image
   // runningAnimation = _spriteAnimation('Run', 4); //add more frames to bunny on image
    runningAnimation = _spriteAnimation('Run', 12);
   // doubleJumpAnimation = _spriteAnimation('Double Jump', 6);
    fallingAnimation = _spriteAnimation('Fall', 1);
    jumpingAnimation = _spriteAnimation('Jump', 1);
   // wallJumpAnimation = _spriteAnimation('Wall Jump', 5);

    animations = {
      //list of animations, add more as implemented
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      //PlayerState.doubleJump: doubleJumpAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.jumping: jumpingAnimation,
      //PlayerState.wallJumping: wallJumpAnimation,
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
    //if player is falling
    if (velocity.y > 0) {
      playerState = PlayerState.falling; //0 can be changed to _gravity
    }

    //if player is jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    //If moving, set running animation
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  void _updatePlayerPosition(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        //handles all the blocks different from the platforms
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        //handles the platforms
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        //handles the blocks
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            //falling
            velocity.y = 0; //if the code stops here, you have quicksand!
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true; //for the jumping
            break;
          }
          if (velocity.y < 0) {
            //going up
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            break;
          }
        }
      }
    }
  }
}
