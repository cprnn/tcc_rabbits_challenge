import 'dart:async';
import 'dart:html' as html;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tcc_rabbits_challenge/components/checkpoint.dart';
import 'package:tcc_rabbits_challenge/components/collision_block.dart';
import 'package:tcc_rabbits_challenge/components/custom_hitbox.dart';
import 'package:tcc_rabbits_challenge/components/fruit.dart';
import 'package:tcc_rabbits_challenge/components/saw.dart';
import 'package:tcc_rabbits_challenge/components/score.dart';
import 'package:tcc_rabbits_challenge/components/utils.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

enum PlayerState {
  //TODO: add more player states
  idle,
  running,
  doubleJump,
  falling,
  jumping,
  wallJumping,
  hit,
  appearing,
  disappearing,
}

enum Direction { left, right }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<RabbitsChallenge>, KeyboardHandler, CollisionCallbacks {
  //TODO:after add blockly, remove keyboard controls
  String character;
  //constructor
  // ignore: use_super_parameters
  Player(
      {super.position,
      this.character =
          'Snow'}); //super extends the SpriteAnimationGroupComponent

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation wallJumpAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

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
  double moveDistance =
      16.0; //Exactly the width of the widget of the block painted as the ground in Tiled - 32 pixels

//Checks collisions and if jumped
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;

//Player's starting spawpoint
  Vector2 startingPosition = Vector2.zero();

  List<CollisionBlock> collisionBlocks = [];

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  Direction _direction = Direction.right;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    startingPosition = Vector2(position.x, position.y);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    html.window.onMessage.listen((event) {
      if (event.data['action'] == 'change_direction') {
        if (event.data['direction'] == 'left') {
          _direction = Direction.left;
        } else if (event.data['direction'] == 'right') {
          _direction = Direction.right;
        }
      } else if (event.data['action'] == 'move_player') {
        if (event.data['direction'] == 'left') {
          _direction = Direction.left;
          _movePlayerOverTime(-1);
        } else if (event.data['direction'] == 'right') {
          _direction = Direction.right;
          _movePlayerOverTime(1);
        }
      } else if (event.data['action'] == 'jump') {
        hasJumped = true;
      }
    });

    return super.onLoad();
  }

  @override
  void update(double dt) {
    //dt: delta time

    if (!gotHit && !reachedCheckpoint) {
      _updatePlayerState();
      _updatePlayerPosition(dt);

      _checkHorizontalCollisions();
      _applyGravity(dt);

      _checkVerticalCollisions();
    }
    super.update(dt);
  }

//player movement - moves the player for only 32 pixels
  void _movePlayer(double distance) {
    position.x += distance;
  }

  void _movePlayerOverTime(double direction) {
    double stepTime =
        0.01; // adjust this value to control the smoothness of the movement
    int steps = (moveDistance / moveSpeed / stepTime).toInt();
    double stepDistance = moveDistance / steps;

    for (int i = 0; i < steps; i++) {
      _movePlayer(stepDistance * direction);
      Future.delayed(Duration(milliseconds: (stepTime * 1000).toInt()));
    }
    // Ensure the player is moved exactly _moveDistance pixels
    position.x = (position.x + direction * moveDistance).roundToDouble();
  }

  Score score = Score();

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Fruit) {
        other.collidedWithPlayer();
        score.incrementFruitsCollected();
      }
      if (other is Saw) _respawn();
      if (other is Checkpoint) _reachedCheckpoint();
      super.onCollisionStart(intersectionPoints, other);
    }
  }

  void _loadAllAnimations() {
    //TODO: make this more dynamic after removing the hard coded path on _spriteAnimation
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    fallingAnimation = _spriteAnimation('Fall', 1);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    hitAnimation = _spriteAnimation('Hit', 6)
      ..loop = false; //cascade operator, read more about it
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Disappearing', 7);

    // idleAnimation = _spriteAnimation('Idle', 4); //add more frames to bunny on image
    // runningAnimation = _spriteAnimation('Run', 4); //add more frames to bunny on image
    // doubleJumpAnimation = _spriteAnimation('Double Jump', 6);
    // wallJumpAnimation = _spriteAnimation('Wall Jump', 5);

    animations = {
      //list of animations, add more as implemented
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      //PlayerState.doubleJump: doubleJumpAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.jumping: jumpingAnimation,
      //PlayerState.wallJumping: wallJumpAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

//set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Main Characters/$character/$state (32x32).png'), //TODO: make this more dynamic, no hard coded paths
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }

//after correcting the hard coded _spriteAnimation, adapt or remove _specialSpriteAnimation
  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Main Characters/$state (96x96).png'), //TODO: make this more dynamic, no hard coded paths
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (_direction == Direction.left && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_direction == Direction.right && scale.x < 0) {
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
    if (!gotHit && !reachedCheckpoint) {
      if (velocity.x != 0) {
        position.x += velocity.x * dt;
      }
      if (hasJumped) {
        _playerJump(dt);
        hasJumped = false;
      }
    }
  }

/*  void _updatePlayerPosition(double dt) {
    if (!gotHit && !reachedCheckpoint) {
      horizontalMovement = 0;
      if (_direction == Direction.left) {
        horizontalMovement = -moveSpeed;
      } else if (_direction == Direction.right) {
        horizontalMovement = moveSpeed;
      }
      velocity.x = horizontalMovement;
      position.x += velocity.x * dt;
    }
  }
*/

  void _playerJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
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

  void _respawn() async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    const canMoveDuration = Duration(milliseconds: 50);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed; //used to check if the animation finished
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint() async {
    if (game.playSounds) {
      FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }
    reachedCheckpoint = true;
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    const waitToChangeLevelDuration = Duration(seconds: 3);
    Future.delayed(waitToChangeLevelDuration, () => game.loadNextLevel());
  }

  void resetPosition() {
    position = startingPosition;
  }
}
