import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../dui_dev_config.dart';
import '../../init/digia_ui_manager.dart';

class InternalLottie extends StatefulWidget {
  final String lottiePath;
  final Alignment alignment;
  final double? height;
  final double? width;
  final bool animate;
  final FrameRate frameRate;
  final BoxFit? fit;
  final bool repeat;
  final bool reverse;
  final VoidCallback? onComplete;

  const InternalLottie({
    super.key,
    required this.lottiePath,
    required this.alignment,
    required this.height,
    required this.width,
    required this.animate,
    required this.frameRate,
    required this.fit,
    required this.repeat,
    required this.reverse,
    this.onComplete,
  });

  @override
  State<InternalLottie> createState() => _InternalLottieState();
}

class _InternalLottieState extends State<InternalLottie>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  bool _hasTriggeredOnComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(InternalLottie oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lottiePath != widget.lottiePath ||
        oldWidget.repeat != widget.repeat ||
        oldWidget.reverse != widget.reverse ||
        oldWidget.animate != widget.animate) {
      _resetController();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _initializeController() {
    if (!widget.animate) return;

    _animationController = AnimationController(vsync: this);

    // Only listen for completion when animation type is 'once' (not repeating)
    if (!widget.repeat && widget.onComplete != null) {
      _animationController!.addStatusListener(_onAnimationStatus);
    }
  }

  void _resetController() {
    _animationController?.dispose();
    _hasTriggeredOnComplete = false;
    _initializeController();
    if (mounted) {
      setState(() {});
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_hasTriggeredOnComplete) {
      _hasTriggeredOnComplete = true;
      widget.onComplete?.call();
    }
  }

  Widget _buildErrorPlaceholder() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: const Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
    );
  }

  String _getFinalUrl(String path) {
    if (!path.startsWith('http')) {
      return path;
    }

    final DigiaUIHost? host = DigiaUIManager().host;
    if (host is DashboardHost && host.resourceProxyUrl != null) {
      return '${host.resourceProxyUrl}${Uri.encodeFull(path)}';
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lottiePath.isEmpty) {
      return _buildErrorPlaceholder();
    }

    final finalUrl = _getFinalUrl(widget.lottiePath);
    final isNetworkUrl = widget.lottiePath.startsWith('http');

    if (isNetworkUrl) {
      return LottieBuilder.network(
        finalUrl,
        alignment: widget.alignment,
        height: widget.height,
        width: widget.width,
        controller: _animationController,
        animate: widget.animate && _animationController == null,
        frameRate: widget.frameRate,
        fit: widget.fit,
        repeat: widget.repeat,
        reverse: widget.reverse,
        onLoaded: (composition) {
          if (_animationController != null && widget.animate) {
            _animationController!
              ..duration = composition.duration
              ..reset()
              ..forward();
          }
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }

    return LottieBuilder.asset(
      widget.lottiePath,
      alignment: widget.alignment,
      height: widget.height,
      width: widget.width,
      controller: _animationController,
      animate: widget.animate && _animationController == null,
      frameRate: widget.frameRate,
      fit: widget.fit,
      repeat: widget.repeat,
      reverse: widget.reverse,
      onLoaded: (composition) {
        if (_animationController != null && widget.animate) {
          _animationController!
            ..duration = composition.duration
            ..reset()
            ..forward();
        }
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
    );
  }
}
