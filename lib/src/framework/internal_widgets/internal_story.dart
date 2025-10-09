import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import '../data_type/adapted_types/story_controller.dart';

class InternalStory extends StatefulWidget {
  final AdaptedStoryController controller;
  final List<StoryItem> storyItems;
  final VoidCallback? onComplete;
  final bool repeat;
  final Widget? header;
  final Widget? footer;

  const InternalStory({
    super.key,
    required this.controller,
    required this.storyItems,
    this.onComplete,
    this.repeat = false,
    this.header,
    this.footer,
  });

  @override
  State<InternalStory> createState() => _InternalStoryState();
}

class _InternalStoryState extends State<InternalStory> {
  Key _storyKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FlutterStoryPresenter(
      key: _storyKey,
      flutterStoryController: widget.controller,
      items: widget.storyItems,
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
