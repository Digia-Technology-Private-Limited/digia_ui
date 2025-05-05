import 'package:flutter/material.dart';

class DSOverlayController {
  _InternalOverlayState? _overlayState;

  void show() => _overlayState?.showOverlay();
  void hide() => _overlayState?.hideOverlay();
  void toggle() => _overlayState?.toggleOverlay();
  bool get isVisible => _overlayState?.isVisible ?? false;
}

class InternalOverlay extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, DSOverlayController controller)
      popupBuilder;
  final DSOverlayController? controller;
  final bool showOnTap;
  final bool dismissOnTapOutside;
  final bool dismissOnTapInside;
  final Offset offset;
  final Alignment childAlignment;
  final Alignment popupAlignment;

  const InternalOverlay({
    Key? key,
    required this.child,
    required this.popupBuilder,
    this.controller,
    this.showOnTap = true,
    this.dismissOnTapOutside = true,
    this.dismissOnTapInside = false,
    this.offset = Offset.zero,
    this.childAlignment = Alignment.topLeft,
    this.popupAlignment = Alignment.topLeft,
  }) : super(key: key);

  @override
  _InternalOverlayState createState() => _InternalOverlayState();
}

class _InternalOverlayState extends State<InternalOverlay> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late DSOverlayController _controller;
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DSOverlayController();
    _controller._overlayState = this;
  }

  @override
  void dispose() {
    hideOverlay();
    _controller._overlayState = null;
    super.dispose();
  }

  void showOverlay() {
    if (_isVisible) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _OverlayContent(
        link: _layerLink,
        offset: widget.offset,
        childAlignment: widget.childAlignment,
        popupAlignment: widget.popupAlignment,
        dismissOnTapOutside: widget.dismissOnTapOutside,
        dismissOnTapInside: widget.dismissOnTapInside,
        onDismiss: hideOverlay,
        child: widget.popupBuilder(context, _controller),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isVisible = true);
  }

  void hideOverlay() {
    if (!_isVisible) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isVisible = false);
  }

  void toggleOverlay() {
    _isVisible ? hideOverlay() : showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.showOnTap
          ? GestureDetector(
              onTap: showOverlay,
              child: widget.child,
            )
          : widget.child,
    );
  }
}

class _OverlayContent extends StatelessWidget {
  final LayerLink link;
  final Offset offset;
  final Alignment childAlignment;
  final Alignment popupAlignment;
  final bool dismissOnTapOutside;
  final bool dismissOnTapInside;
  final VoidCallback onDismiss;
  final Widget child;

  const _OverlayContent({
    Key? key,
    required this.link,
    required this.offset,
    required this.childAlignment,
    required this.popupAlignment,
    required this.dismissOnTapOutside,
    required this.dismissOnTapInside,
    required this.onDismiss,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: dismissOnTapOutside ? onDismiss : null,
      child: Stack(
        children: [
          CompositedTransformFollower(
            link: link,
            showWhenUnlinked: false,
            offset: offset,
            targetAnchor: childAlignment,
            followerAnchor: popupAlignment,
            child: dismissOnTapInside
                ? _TapDetector(
                    onTapUp: () {
                      onDismiss();
                    },
                    child: child,
                  )
                : child,
          ),
        ],
      ),
    );
  }
}

class _TapDetector extends StatefulWidget {
  final VoidCallback onTapUp;
  final Widget child;

  const _TapDetector({
    Key? key,
    required this.onTapUp,
    required this.child,
  }) : super(key: key);

  @override
  _TapDetectorState createState() => _TapDetectorState();
}

class _TapDetectorState extends State<_TapDetector> {
  Offset? _touchDownPosition;
  bool _hasScrolled = false;

  static const double _kTapSlop = 18.0; // Maximum movement allowed for a tap

  void _handlePointerDown(PointerDownEvent event) {
    _touchDownPosition = event.position;
    _hasScrolled = false;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_touchDownPosition != null) {
      final distance = (event.position - _touchDownPosition!).distance;
      if (distance > _kTapSlop) {
        _hasScrolled = true;
      }
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_touchDownPosition != null && !_hasScrolled) {
      widget.onTapUp();
    }
    _touchDownPosition = null;
    _hasScrolled = false;
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _touchDownPosition = null;
    _hasScrolled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: widget.child,
    );
  }
}
