import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonBounceAnimation extends StatefulWidget {
  const ButtonBounceAnimation({
    super.key,
    required this.child,
    required this.onPressed,
    this.shouldSupportEnterKey = false,
    this.enableHaptics = true,
    this.enableBounceAnimation = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool shouldSupportEnterKey;
  final bool enableHaptics;
  final bool enableBounceAnimation;

  @override
  State<ButtonBounceAnimation> createState() => _ButtonBounceAnimationState();
}

class _ButtonBounceAnimationState extends State<ButtonBounceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceAnimationController;
  late final Animation<double> _buttonSizeScale;
  // late final _focusNode = FocusNode();
  late Completer _animationCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _bounceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _buttonSizeScale =
        Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(
      parent: _bounceAnimationController,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  void didUpdateWidget(covariant ButtonBounceAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimationController,
      builder: (_, Widget? child) {
        return Transform.scale(
          scale: _buttonSizeScale.value,
          child: child!,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _forwardAnimation(),
        onTapUp: (_) => _callOnPressed(),
        onTapCancel: () => _reverseAnimation(),
        // child: widget.shouldSupportEnterKey
        //     ? KeyboardListener(
        //         focusNode: _focusNode,
        //         onKeyEvent: (KeyEvent event) {
        //           if (event.logicalKey == LogicalKeyboardKey.enter) {
        //             FocusScope.of(context).requestFocus(_focusNode);
        //             _callOnPressed();
        //           }
        //         },
        //         child: widget.child,
        //       )
        //     : widget.child,
        child: AbsorbPointer(child: widget.child),
      ),
    );
  }

  void _forwardAnimation() {
    if (widget.onPressed != null && widget.enableBounceAnimation) {
      try {
        return _animationCompleter
            .complete(_bounceAnimationController.forward());
      } catch (_) {
        widget.onPressed?.call();
        _animationCompleter = Completer();
        debugPrint(
          'digia_ui: _forwardAnimation() failed on button tap.\n Ignored as it is handled and then logged.',
        );
      }
    } else {
      widget.onPressed?.call();
    }
  }

  Future _reverseAnimation() async {
    if (mounted) {
      await _animationCompleter.future;
      _animationCompleter = Completer();
      if (widget.enableHaptics) {
        HapticFeedback.lightImpact();
      }
      await _bounceAnimationController.reverse();
    }
  }

  Future _callOnPressed() async {
    await _reverseAnimation();
    return widget.onPressed?.call();
  }

  @override
  void dispose() {
    _bounceAnimationController.dispose();
    // if (widget.shouldSupportEnterKey) {
    //   _focusNode.dispose();
    // }
    super.dispose();
  }
}
