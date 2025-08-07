import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';

class AnimatedMarkdown extends StatefulWidget {
  final String data;
  final bool shrinkWrap;
  final bool selectable;
  final MarkdownConfig config;
  final Duration duration;

  const AnimatedMarkdown({
    super.key,
    required this.data,
    this.duration = const Duration(milliseconds: 20),
    required this.shrinkWrap,
    required this.selectable,
    required this.config,
  });

  @override
  State<AnimatedMarkdown> createState() => _AnimatedMarkdownState();
}

class _AnimatedMarkdownState extends State<AnimatedMarkdown> {
  String _visibleText = '';
  int _charIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_charIndex < widget.data.length) {
        setState(() {
          _charIndex++;
          _visibleText = widget.data.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownWidget(
      data: _visibleText,
      shrinkWrap: widget.shrinkWrap,
      selectable: widget.selectable,
      config: widget.config,
    );
  }
}
