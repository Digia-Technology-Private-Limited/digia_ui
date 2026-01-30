import 'package:flutter/material.dart';

import '../../scratchify/scratch_card.dart';
import '../../scratchify/scratch_config.dart';
import '../../scratchify/scratch_controller.dart';

class InternalScratchCard extends StatefulWidget {
  final Widget overlay;
  final Widget child;
  final double? height;
  final double? width;
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
  final VoidCallback? onScratchComplete;

  const InternalScratchCard({
    super.key,
    required this.overlay,
    required this.child,
    this.height,
    this.width,
    this.revealFullAtPercent = 0.5,
    this.isScratchingEnabled = true,
    this.gridResolution = 100,
    this.enableTapToScratch = false,
    this.brushSize = 20.0,
    this.brushColor = Colors.transparent,
    this.brushOpacity = 1.0,
    this.brushShape = BrushShape.circle,
    this.enableHapticFeedback = false,
    this.revealAnimationType = RevealAnimationType.none,
    this.animationDurationMs = 500,
    this.enableProgressAnimation = false,
    this.onScratchComplete,
  });

  @override
  State<InternalScratchCard> createState() => _InternalScratchCardState();
}

class _InternalScratchCardState extends State<InternalScratchCard> {
  late ScratchController _controller;
  bool _wasCompleted = false;
  bool isInProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = ScratchController(
      config: ScratchConfig(
        revealFullAtPercent: widget.revealFullAtPercent,
        isScratchingEnabled: widget.isScratchingEnabled,
        gridResolution: widget.gridResolution,
        enableTapToScratch: widget.enableTapToScratch,
        brushSize: widget.brushSize,
        brushColor: widget.brushColor,
        brushOpacity: widget.brushOpacity,
        brushShape: widget.brushShape,
        enableHapticFeedback: widget.enableHapticFeedback,
        revealAnimationType: widget.revealAnimationType,
        animationDurationMs: widget.animationDurationMs,
        enableProgressAnimation: widget.enableProgressAnimation,
      ),
    );
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (_controller.progress > 0 && !isInProgress) {
      isInProgress = true;
      setState(() {});
    }
    if (_controller.isCompleted && !_wasCompleted) {
      _wasCompleted = true;
      widget.onScratchComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ScratchCard(
        controller: _controller,
        overlay: widget.overlay,
        child: isInProgress ? widget.child : Container(),
      ),
    );
  }
}
