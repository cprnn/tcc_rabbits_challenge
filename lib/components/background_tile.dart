import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';

//TODO: see if the scrolling background will be necessary
class BackgroundTile extends ParallaxComponent {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    super.position,
  });

  final double scrollSpeed = 20; //if faster, dizzy

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(
        64); //if use new backgrounds, make sure to make them all 64x64 bits!
    parallax = await game.loadParallax(
        [ParallaxImageData('Background/$color.png')],
        baseVelocity: Vector2(0, -scrollSpeed),
        repeat: ImageRepeat.repeat,
        fill: LayerFill.none);
    return super.onLoad();
  }
}
