import 'package:flutter/material.dart';

import '../../scratchify/scratch_config.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/internal_scratch_card.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../widget_props/scratch_card_props.dart';

class VWScratchCard extends VirtualStatelessWidget<ScratchCardProps> {
  VWScratchCard({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  BrushShape _parseBrushShape(String? shape) {
    switch (shape) {
      case 'circle':
        return BrushShape.circle;
      case 'square':
        return BrushShape.square;
      case 'star':
        return BrushShape.star;
      case 'heart':
        return BrushShape.heart;
      case 'diamond':
        return BrushShape.diamond;
      default:
        return BrushShape.circle;
    }
  }

  RevealAnimationType _parseRevealAnimationType(String? type) {
    switch (type) {
      case 'none':
        return RevealAnimationType.none;
      case 'fade':
        return RevealAnimationType.fade;
      case 'scale':
        return RevealAnimationType.scale;
      case 'slideup':
        return RevealAnimationType.slideUp;
      case 'slidedown':
        return RevealAnimationType.slideDown;
      case 'slideleft':
        return RevealAnimationType.slideLeft;
      case 'slideright':
        return RevealAnimationType.slideRight;
      case 'bounce':
        return RevealAnimationType.bounce;
      case 'zoomout':
        return RevealAnimationType.zoomOut;
      default:
        return RevealAnimationType.none;
    }
  }

  @override
  Widget render(RenderPayload payload) {
    final overlay = childOf('overlay');
    final child = childOf('base');
    if (overlay == null || child == null) return empty();

    return InternalScratchCard(
      overlay: overlay.toWidget(payload),
      height: props.height?.toHeight(payload.buildContext),
      width: props.width?.toWidth(payload.buildContext),
      brushSize: payload.evalExpr(props.brushSize) ?? 20.0,
      revealFullAtPercent:
          (payload.evalExpr(props.revealFullAtPercent) ?? 75) / 100,
      isScratchingEnabled: payload.evalExpr(props.isScratchingEnabled) ?? true,
      gridResolution: payload.evalExpr(props.gridResolution) ?? 100,
      enableTapToScratch: payload.evalExpr(props.enableTapToScratch) ?? false,
      brushColor: payload.evalColorExpr(props.brushColor) ?? Colors.transparent,
      brushOpacity: payload.evalExpr(props.brushOpacity) ?? 1.0,
      brushShape: _parseBrushShape(payload.evalExpr(props.brushShape)),
      enableHapticFeedback:
          payload.evalExpr(props.enableHapticFeedback) ?? false,
      revealAnimationType: _parseRevealAnimationType(
          payload.evalExpr(props.revealAnimationType)),
      animationDurationMs: payload.evalExpr(props.animationDurationMs) ?? 500,
      enableProgressAnimation:
          payload.evalExpr(props.enableProgressAnimation) ?? false,
      onScratchComplete: () async {
        await payload.executeAction(
          props.onScratchComplete,
          triggerType: 'onScratchComplete',
        );
      },
      child: child.toWidget(payload),
    );
  }
}
