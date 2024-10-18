import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tcc_rabbits_challenge/components/score.dart';

class ScoreDisplay extends TextComponent {
  final Score score;

  ScoreDisplay(this.score)
      : super(
          text: 'Score: ${score.getFruitsCollected()}',
          textRenderer: TextPaint(style: const TextStyle(color: Colors.white)),
        );

  @override
  void update(double dt) {
    super.update(dt);
    text = 'Score: ${score.getFruitsCollected()}'; // Update score display
  }
}