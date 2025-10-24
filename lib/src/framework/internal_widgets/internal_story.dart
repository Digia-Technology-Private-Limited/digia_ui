import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import '../data_type/adapted_types/story_controller.dart';
import '../render_payload.dart';

class InternalStory extends StatefulWidget {
  final AdaptedStoryController controller;
  final List<Widget> widgets;
  final VoidCallback? onComplete;
  final void Function(DragUpdateDetails)? onSlideDown;
  final void Function(DragStartDetails)? onSlideStart;
  final Future<bool> Function()? onLeftTap;
  final Future<bool> Function()? onRightTap;
  final VoidCallback? onPreviousCompleted;
  final void Function(int)? onStoryChanged;
  final bool repeat;
  final int initialIndex;
  final Widget? header;
  final Widget? footer;
  final StoryViewIndicatorConfig? storyViewIndicatorConfig;
  final Duration defaultDuration;
  final RenderPayload payload;

  const InternalStory({
    super.key,
    required this.controller,
    required this.widgets,
    this.onComplete,
    this.onSlideDown,
    this.onSlideStart,
    this.initialIndex=0,
    this.onLeftTap,
    this.onRightTap,
    this.onPreviousCompleted,
    this.onStoryChanged,
    this.storyViewIndicatorConfig,
    this.repeat = false,
    this.header,
    this.footer,
    this.defaultDuration = const Duration(seconds: 3),
    required this.payload,
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
      initialIndex: widget.initialIndex,
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
      onSlideDown: widget.onSlideDown,
      onSlideStart: widget.onSlideStart,
      onLeftTap: widget.onLeftTap,
      onRightTap: widget.onRightTap,
      onPreviousCompleted: () {
        widget.onPreviousCompleted?.call();
        return Future.value();
      },
      onStoryChanged: widget.onStoryChanged,
      headerWidget: widget.header,
      footerWidget: widget.footer,
    );
  }
}
