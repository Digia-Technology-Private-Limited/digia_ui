import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scratch_config.dart';
import 'scratch_grid.dart';

class ScratchController extends ChangeNotifier {
  final ScratchGrid grid;
  bool isCompleted = false;
  bool _isRevealing = false;
  final ScratchConfig config;

  ScratchController({required this.config})
      : grid = ScratchGrid(
          rows: config.gridResolution,
          cols: config.gridResolution,
        );

  void scratchAt(Offset position, Size size) {
    if (!config.isScratchingEnabled || isCompleted) return;

    final cellW = size.width / grid.cols;
    final cellH = size.height / grid.rows;
    final avgCellSize = (cellW + cellH) / 2;

    if (avgCellSize <= 0) return;

    final brushRadiusCells = (config.brushSize / 2) / avgCellSize;
    final radius = brushRadiusCells.ceil();

    final centerRow = ((position.dy / size.height) * grid.rows).floor();
    final centerCol = ((position.dx / size.width) * grid.cols).floor();

    for (int dr = -radius; dr <= radius; dr++) {
      for (int dc = -radius; dc <= radius; dc++) {
        final nr = dr / brushRadiusCells; // normalized [-1, 1]
        final nc = dc / brushRadiusCells;

        if (nr.abs() > 1 || nc.abs() > 1) continue;

        bool shouldScratch = false;

        switch (config.brushShape) {
          case BrushShape.circle:
            shouldScratch = (nr * nr + nc * nc) <= 1.0;
            break;

          case BrushShape.square:
            shouldScratch = nr.abs() <= 1.0 && nc.abs() <= 1.0;
            break;

          case BrushShape.diamond:
            shouldScratch = (nr.abs() + nc.abs()) <= 1.0;
            break;

          case BrushShape.star:
            final angle = atan2(nr, nc);
            const spikes = 5;
            const innerRadius = 0.4;
            const outerRadius = 1.0;

            final radiusFactor =
                (sin(angle * spikes).abs() * (outerRadius - innerRadius)) +
                    innerRadius;

            shouldScratch = sqrt(nr * nr + nc * nc) <= radiusFactor;
            break;

          case BrushShape.heart:
            {
              final x = nc; // [-1, 1]
              final y = -nr; // invert Y for natural orientation

              // Top circles
              final leftCircle = pow(x + 0.35, 2) + pow(y - 0.25, 2) <= 0.25;
              final rightCircle = pow(x - 0.35, 2) + pow(y - 0.25, 2) <= 0.25;

              // Bottom triangle (smooth taper)
              final triangle =
                  y <= 0.25 && y >= -0.9 && x.abs() <= (0.9 - (-y)) * 0.7;

              shouldScratch = leftCircle || rightCircle || triangle;
              break;
            }
        }

        if (shouldScratch) {
          grid.scratch(centerRow + dr, centerCol + dc);
        }
      }
    }

    if (config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    final currentProgress = grid.progress();
    if (!isCompleted &&
        !_isRevealing &&
        currentProgress >= config.revealFullAtPercent) {
      _isRevealing = true;

      if (config.enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        isCompleted = true;
        notifyListeners();
      });
    }

    notifyListeners();
  }

  void reset() {
    grid.reset();
    isCompleted = false;
    _isRevealing = false;
    notifyListeners();
  }

  void reveal() {
    _isRevealing = true;
    isCompleted = true;
    notifyListeners();
  }

  double get progress => grid.progress();
  bool get isRevealing => _isRevealing;
}
