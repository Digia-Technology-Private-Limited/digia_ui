import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import '../data_type/adapted_types/story_controller.dart';

class InternalStory extends StatefulWidget {
  final AdaptedStoryController controller;
  final List<Widget> widgets;
  final VoidCallback? onComplete;
  final bool repeat;
  final Widget? header;
  final Widget? footer;
  final StoryViewIndicatorConfig? storyViewIndicatorConfig;
  final Duration defaultDuration;

  const InternalStory({
    super.key,
    required this.controller,
    required this.widgets,
    this.onComplete,
    this.storyViewIndicatorConfig,
    this.repeat = false,
    this.header,
    this.footer,
    this.defaultDuration = const Duration(seconds: 3),
  });

  @override
  State<InternalStory> createState() => _InternalStoryState();
}

class _InternalStoryState extends State<InternalStory> {
  Key _storyKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FlutterStoryPresenterWidgets(
      key: _storyKey,
      restartOnCompleted: widget.repeat,
      flutterStoryController: widget.controller,
      widgets: widget.widgets,
      storyViewIndicatorConfig: widget.storyViewIndicatorConfig,
      defaultDuration: widget.defaultDuration,
      onCompleted: () {
        widget.onComplete?.call();
        if (widget.repeat) {
          setState(() {
            _storyKey = UniqueKey();
          });
        }
        return Future.value();
      },
      headerWidget: widget.header,
      footerWidget: widget.footer,
    );
  }
}
