import 'package:flutter/material.dart';

enum BrushShape { circle, square, star, heart, diamond }

enum RevealAnimationType {
  none,
  fade,
  scale,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  bounce,
  zoomOut,
}

class ScratchConfig {
  final double revealFullAtPercent;
  final bool isScratchingEnabled;
  final int gridResolution;
  final bool enableTapToScratch;
  final double brushSize;
  final Color brushColor;
  final double brushOpacity;
  final BrushShape brushShape;
  final bool enableHapticFeedback;
  final RevealAnimationType revealAnimationType;
  final int animationDurationMs;
  final bool enableProgressAnimation;

  const ScratchConfig({
    this.revealFullAtPercent = 0.75,
    this.isScratchingEnabled = true,
    this.gridResolution = 150,
    this.enableTapToScratch = true,
    this.brushSize = 20.0,
    this.brushColor = Colors.transparent,
    this.brushOpacity = 1.0,
    this.brushShape = BrushShape.circle,
    this.enableHapticFeedback = true,
    this.revealAnimationType = RevealAnimationType.fade,
    this.animationDurationMs = 500,
    this.enableProgressAnimation = true,
  });
}
