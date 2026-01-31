import 'package:flutter/material.dart';
import 'scratch_config.dart';
import 'scratch_controller.dart';
import 'scratch_grid.dart';
import 'scratch_painter.dart';

class ScratchCard extends StatefulWidget {
  final Widget child; // revealed content
  final Widget overlay; // overlay to scratch
  final ScratchController controller;

  const ScratchCard({
    super.key,
    required this.overlay,
    required this.controller,
    required this.child,
  });

  @override
  State<ScratchCard> createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return AnimatedBuilder(
          animation: widget.controller,
          builder: (context, _) {
            final isPaintMode =
                widget.controller.config.brushColor != Colors.transparent;

            if (isPaintMode) {
              // Paint mode: overlay as background, paint on top
              Widget animatedMask = _buildAnimatedMask(
                CustomPaint(
                  painter: ScratchMaskPainter(
                    widget.controller.grid,
                    widget.controller.config,
                  ),
                  size: size,
                ),
                widget.controller.config.revealAnimationType,
                widget.controller.isCompleted,
                widget.controller.config.animationDurationMs,
                progress: widget.controller.progress,
                enableProgressAnimation:
                    widget.controller.config.enableProgressAnimation,
                isRevealing: widget.controller.isRevealing,
              );

              return Stack(
                children: [
                  widget.overlay,
                  if (!widget.controller.isCompleted ||
                      widget.controller.config.revealAnimationType ==
                          RevealAnimationType.none)
                    animatedMask,
                  GestureDetector(
                    onPanUpdate: widget.controller.isCompleted
                        ? null
                        : (details) => widget.controller.scratchAt(
                              details.localPosition,
                              size,
                            ),
                    onTapDown: widget.controller.isCompleted ||
                            !widget.controller.config.enableTapToScratch
                        ? null
                        : (details) => widget.controller.scratchAt(
                              details.localPosition,
                              size,
                            ),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              );
            } else {
              // Scratch mode: child as background, overlay clipped
              Widget animatedOverlay = _buildAnimatedOverlay(
                ClipPath(
                  clipper: _GridClipper(widget.controller.grid),
                  child: widget.overlay,
                ),
                widget.controller.config.revealAnimationType,
                widget.controller.isCompleted,
                widget.controller.config.animationDurationMs,
                progress: widget.controller.progress,
                enableProgressAnimation:
                    widget.controller.config.enableProgressAnimation,
                isRevealing: widget.controller.isRevealing,
              );

              return Stack(
                children: [
                  widget.child,
                  if (!widget.controller.isCompleted ||
                      widget.controller.config.revealAnimationType ==
                          RevealAnimationType.none)
                    animatedOverlay,
                  GestureDetector(
                    onPanUpdate: widget.controller.isCompleted
                        ? null
                        : (details) => widget.controller.scratchAt(
                              details.localPosition,
                              size,
                            ),
                    onTapDown: widget.controller.isCompleted ||
                            !widget.controller.config.enableTapToScratch
                        ? null
                        : (details) => widget.controller.scratchAt(
                              details.localPosition,
                              size,
                            ),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

class _GridClipper extends CustomClipper<Path> {
  final ScratchGrid grid;

  _GridClipper(this.grid);

  @override
  Path getClip(Size size) {
    final path = Path();
    final cellW = size.width / grid.cols;
    final cellH = size.height / grid.rows;

    for (int r = 0; r < grid.rows; r++) {
      for (int c = 0; c < grid.cols; c++) {
        if (!grid.isScratched(r, c)) {
          path.addRect(Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH));
        }
      }
    }
    return path;
  }

  @override
  bool shouldReclip(covariant _GridClipper old) => true;
}

Widget _buildAnimatedMask(
  Widget child,
  RevealAnimationType type,
  bool isCompleted,
  int durationMs, {
  double? progress,
  bool enableProgressAnimation = false,
  bool isRevealing = false,
}) {
  final duration = Duration(milliseconds: durationMs);
  final animValue = enableProgressAnimation &&
          progress != null &&
          (isCompleted || isRevealing)
      ? (isCompleted ? 1.0 : progress.clamp(0.0, 1.0))
      : (isCompleted ? 1.0 : 0.0);

  switch (type) {
    case RevealAnimationType.none:
      return (enableProgressAnimation ? progress == 1.0 : isCompleted)
          ? SizedBox.shrink()
          : child;
    case RevealAnimationType.fade:
      return AnimatedOpacity(
        opacity: enableProgressAnimation
            ? (1.0 - animValue)
            : (isCompleted ? 0.0 : 1.0),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.scale:
      return AnimatedScale(
        scale: enableProgressAnimation
            ? (1.0 - animValue)
            : (isCompleted ? 0.0 : 1.0),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideUp:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(0, -animValue)
            : (isCompleted ? Offset(0, -1) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideDown:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(0, animValue)
            : (isCompleted ? Offset(0, 1) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideLeft:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(-animValue, 0)
            : (isCompleted ? Offset(-1, 0) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideRight:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(animValue, 0)
            : (isCompleted ? Offset(1, 0) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.bounce:
      return AnimatedScale(
        scale: enableProgressAnimation
            ? (1.0 - animValue)
            : (isCompleted ? 0.0 : 1.0),
        duration: duration,
        curve: Curves.bounceOut,
        child: child,
      );
    case RevealAnimationType.zoomOut:
      return AnimatedScale(
        scale: enableProgressAnimation
            ? (1.0 + animValue * 0.5)
            : (isCompleted ? 1.5 : 1.0),
        duration: duration,
        child: AnimatedOpacity(
          opacity: enableProgressAnimation
              ? (1.0 - animValue)
              : (isCompleted ? 0.0 : 1.0),
          duration: duration,
          child: child,
        ),
      );
  }
}

Widget _buildAnimatedOverlay(
  Widget child,
  RevealAnimationType type,
  bool isCompleted,
  int durationMs, {
  double? progress,
  bool enableProgressAnimation = false,
  bool isRevealing = false,
}) {
  final duration = Duration(milliseconds: durationMs);
  final animValue = enableProgressAnimation &&
          progress != null &&
          (isCompleted || isRevealing)
      ? (isCompleted ? 1.0 : progress.clamp(0.0, 1.0))
      : (isCompleted ? 1.0 : 0.0);

  switch (type) {
    case RevealAnimationType.none:
      return (enableProgressAnimation ? progress == 1.0 : isCompleted)
          ? SizedBox.shrink()
          : child;
    case RevealAnimationType.fade:
      return AnimatedOpacity(
        opacity: enableProgressAnimation
            ? (1.0 - animValue)
            : (isCompleted ? 0.0 : 1.0),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.scale:
      return AnimatedScale(
        scale: enableProgressAnimation
            ? (1.0 - animValue)
            : (isCompleted ? 0.0 : 1.0),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideUp:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(0, -animValue)
            : (isCompleted ? Offset(0, -1) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideDown:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(0, animValue)
            : (isCompleted ? Offset(0, 1) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideLeft:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(-animValue, 0)
            : (isCompleted ? Offset(-1, 0) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.slideRight:
      return AnimatedSlide(
        offset: enableProgressAnimation
            ? Offset(animValue, 0)
            : (isCompleted ? Offset(1, 0) : Offset.zero),
        duration: duration,
        child: child,
      );
    case RevealAnimationType.bounce:
      return AnimatedScale(
        scale: enableProgressAnimation
            ? (1.0 - animValue)
            : (isCompleted ? 0.0 : 1.0),
        duration: duration,
        curve: Curves.bounceOut,
        child: child,
      );
    case RevealAnimationType.zoomOut:
      return AnimatedScale(
        scale: enableProgressAnimation
            ? (1.0 + animValue * 0.5)
            : (isCompleted ? 1.5 : 1.0),
        duration: duration,
        child: AnimatedOpacity(
          opacity: enableProgressAnimation
              ? (1.0 - animValue)
              : (isCompleted ? 0.0 : 1.0),
          duration: duration,
          child: child,
        ),
      );
  }
}
