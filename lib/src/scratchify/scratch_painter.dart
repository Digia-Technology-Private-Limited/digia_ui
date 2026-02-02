import 'package:flutter/material.dart';
import 'scratch_config.dart';
import 'scratch_grid.dart';

class ScratchMaskPainter extends CustomPainter {
  final ScratchGrid grid;
  final ScratchConfig config;

  ScratchMaskPainter(this.grid, this.config);

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / grid.cols;
    final cellH = size.height / grid.rows;

    // Build path for all scratched cells
    final path = Path();
    for (int r = 0; r < grid.rows; r++) {
      for (int c = 0; c < grid.cols; c++) {
        if (grid.isScratched(r, c)) {
          path.addRect(Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH));
        }
      }
    }

    // Draw the path with brush color and opacity
    final paint = Paint()
      ..color = config.brushColor.withValues(alpha: config.brushOpacity);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ScratchMaskPainter old) => true;
}
