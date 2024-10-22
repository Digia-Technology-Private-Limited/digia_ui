import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
// import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
// import '../../Utils/util_functions.dart';
import '../../core/builders/dui_text_builder.dart';
import '../../core/evaluator.dart';
import '../../framework/utils/functional_util.dart';
import '../DUIText/dui_text.dart';
// import '../dui_icons/icon_helpers/icon_data_serialization.dart';
import 'dezerv_stepper_props.dart';
import 'dz_step.dart';

const double _V_TEXT_LEFT_PADDING = 40;
const double _V_TEXT_BOTTOM_PADDING = 32;
const double _V_TEXT_IN_BETWEEN_PADDING = 4;
const double _MAX_PROGRESS_LENGTH = 300;
// const double _STEP_RADIUS = 10;
// const double _STEP_DIMENSION = _STEP_RADIUS * 2;

class DZStepper extends StatefulWidget {
  const DZStepper(
      {super.key,
      // required this.completedIndex,
      required this.props,
      this.data,
      this.registry});

  // final int completedIndex;
  final DezervStepperProps props;
  final DUIWidgetJsonData? data;
  final DUIWidgetRegistry? registry;

  @override
  State<DZStepper> createState() => _DZStepperState();
}

class _DZStepperState extends State<DZStepper> {
  late double currentIndex;
  late Axis direction;
  late List<DZStep> steps;
  late bool showActiveState;

  /// [sidePadding] is required in horizontal direction so can calculate height of text
  late double sidePadding;
  late double iconRadius;

  @override
  void initState() {
    currentIndex =
        eval<double>(widget.props.currentIndex, context: context) ?? 0;
    steps = widget.props.steps ?? [];
    showActiveState =
        eval<bool>(widget.props.showActiveState, context: context) ?? false;
    sidePadding =
        eval<double>(widget.props.sidePadding, context: context) ?? 40;
    iconRadius = eval<double>(widget.props.iconRadius, context: context) ?? 10;
    direction = Axis.vertical;

    super.initState();
  }

  int get _stepsLength => steps.length;
  int get _stepIndex => currentIndex.toInt() /* ?? widget.completedIndex */;
  late final int _stepCircleIndex = _stepIndex;
  late final double _stepDimension = iconRadius * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: direction == Axis.horizontal
          ? _buildHorizontalStepper()
          : _buildVerticalStepper(),
    );
  }

  Widget _buildHorizontalStepper() {
    List<Widget> buildSteps = [];
    List<Widget> buildTitles = [];

    for (int index = 0; index < _stepsLength; index++) {
      buildSteps.add(_buildStepIcon(index));
      if (index < (_stepsLength - 1)) {
        buildSteps.add(
          Expanded(
            child: _buildProgressBar(index, _MAX_PROGRESS_LENGTH),
          ),
        );
      }

      buildTitles.add(DUITextBuilder.fromProps(
          props: {'text': widget.props.steps![index].title!}).build(context));
    }

    return Column(
      children: [
        Padding(
          padding: _getHorizontalPadding(),
          child: Row(
            children: buildSteps,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buildTitles,
        ),
      ],
    );
  }

  Widget _buildVerticalStepper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        _stepsLength,
        (int index) => _buildVerticalStep(index),
      ),
    );
  }

  Widget _buildVerticalStep(int index) {
    final DZStep dzStep = steps[index];
    final bool isCompleted =
        showActiveState ? index < _stepIndex : index <= _stepCircleIndex;

    double itemLength = _getContentHeight(
        DUIText(widget.props.steps![index].title!),
        DUIText(widget.props.steps![index].subtitle!));
    // When it's small animated icon
    if (showActiveState && !isCompleted) {
      itemLength -= iconRadius;
    } else {
      itemLength -= _stepDimension;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 3,
              ),
              _buildStepIcon(index),
              if (index < (_stepsLength - 1))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: _buildProgressBar(index, itemLength),
                  ),
                ),
            ],
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DUIText(dzStep.title!),
                  if (dzStep.subtitle != null) ...{
                    const SizedBox(height: _V_TEXT_IN_BETWEEN_PADDING),
                    DUIText(dzStep.subtitle!),
                  },
                  if (index < _stepsLength - 1)
                    const SizedBox(height: _V_TEXT_BOTTOM_PADDING)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int index) {
    final bool isActive = index <= _stepCircleIndex;
    final bool isCompleted =
        showActiveState ? index < _stepIndex : index <= _stepCircleIndex;

    Widget? dzStep = Stack(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x14FFFFFF),
          ),
        ),
        Positioned(
          left: 6,
          top: 6,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF969593),
            ),
          ),
        ),
      ],
    );

    Widget? dzIncompleteStep = Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x14FFFFFF),
      ),
    );

    Widget? stepIcon;

    if (showActiveState && index == currentIndex && isActive) {
      stepIcon = dzStep;
    } else {
      if (showActiveState && !isCompleted) {
        stepIcon = dzIncompleteStep;
      } else if (isCompleted) {
        stepIcon = dzStep;
      } else {
        stepIcon = const Icon(Icons.run_circle_outlined);
      }
    }

    return SizedBox(
      width: direction == Axis.vertical ? _stepDimension : null,
      height: direction == Axis.horizontal ? _stepDimension : null,
      child: stepIcon,
    );
  }

  Widget _buildProgressBar(int index, double itemLength) {
    return Container(
      // height: direction == Axis.vertical ? itemLength : 2,
      width: direction == Axis.horizontal ? itemLength : 2,
      margin: EdgeInsets.symmetric(
        horizontal: direction == Axis.horizontal ? 2 : 0,
        vertical: direction == Axis.vertical ? 2 : 0,
      ),
      decoration: BoxDecoration(
        color: index < currentIndex
            ? const Color(0xFF969593)
            : const Color(0x29FFFFFF),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // Widget _buildProgressBar(int index, double itemLength) {
  //   return ProgressBar(
  //     progressValue: index < currentIndex ? itemLength : 0,
  //     barLength: itemLength,
  //     direction: direction,
  //     barColor: widget.props.circleColor,
  //     onComplete: () {
  //       setState(() {
  //         _stepCircleIndex = currentIndex.toInt();
  //       });
  //     },
  //   );
  // }

// Gets first and last title height to adjust and center title in horizontal stepper
  EdgeInsets _getHorizontalPadding() {
    // final double firstTitleWidth = widget.props.firstTitleWidth ?? 24;
    final double firstTitleWidth =
        eval<double>(widget.props.firstTitleWidth, context: context) ?? 24;
    // final double lastTitleWidth = widget.props.lastTitleWidth ?? 24;
    final double lastTitleWidth =
        eval<double>(widget.props.lastTitleWidth, context: context) ?? 24;
    // Divider the title width by 2 to half it and remove step circle radius
    return EdgeInsets.only(
        left: (firstTitleWidth / 2) - iconRadius,
        right: (lastTitleWidth / 2) - iconRadius);
  }

  double _getContentHeight(DUIText title, DUIText? subTitle) {
    final double titleHeight = getTextHeight(
      context: context,
      text: as<String>(title.props.textSpans![0].text),
      textStyle: TextStyle(
          fontSize: eval<double>(
                  title.props.textStyle?.fontToken?.font?['size'],
                  context: context) ??
              16,
          height: eval<double>(
                  title.props.textStyle?.fontToken?.font?['height'],
                  context: context) ??
              1),
      widthToRemove: sidePadding + _V_TEXT_LEFT_PADDING,
    );

    double subTitleHeight = 0;
    if (subTitle != null) {
      subTitleHeight = _V_TEXT_IN_BETWEEN_PADDING;
      subTitleHeight += getTextHeight(
        context: context,
        text: removeAllHtmlTags(as<String>(subTitle.props.textSpans![0].text)),
        textStyle: TextStyle(
            fontSize: eval<double>(
                    title.props.textStyle?.fontToken?.font?['size'],
                    context: context) ??
                14,
            height: eval<double>(
                    title.props.textStyle?.fontToken?.font?['height'],
                    context: context) ??
                1),
        widthToRemove: sidePadding + _V_TEXT_LEFT_PADDING,
      );
    } else {
      subTitleHeight = 8;
    }

    final double itemHeight =
        titleHeight + subTitleHeight + _V_TEXT_BOTTOM_PADDING;

    return itemHeight;
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  int getNoOfTextLines({
    required BuildContext context,
    required String text,
    required TextStyle textStyle,
    double widthToRemove = 40,
  }) {
    final span = TextSpan(text: text, style: textStyle);
    final textPainter =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout(
        maxWidth: MediaQuery.of(context).size.width - widthToRemove);
    final int numLines = textPainter.computeLineMetrics().length;
    return numLines;
  }

// Only DZText and DZHtmlText is accepted
// Currently it's dynamic until a super class is made
  double getTextHeight({
    required BuildContext context,
    required String text,
    required TextStyle? textStyle,
    double widthToRemove = 40,
  }) {
    if (textStyle == null) {
      return 0;
    }

    final int noOfLinesTitle = getNoOfTextLines(
      context: context,
      text: text,
      textStyle: textStyle,
      widthToRemove: widthToRemove,
    );
    return (noOfLinesTitle *
        (textStyle.fontSize! * textStyle.height!)); // To get height
  }
}

// class ProgressBar extends StatefulWidget {
//   final double progressValue;
//   final double barLength;
//   final Axis direction;
//   final VoidCallback? onComplete;
//   final String? barColor;

//   const ProgressBar(
//       {super.key,
//       required this.progressValue,
//       required this.barLength,
//       this.direction = Axis.horizontal,
//       this.onComplete,
//       this.barColor});

//   @override
//   State<ProgressBar> createState() => _ProgressBarState();
// }

// class _ProgressBarState extends State<ProgressBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _progressAnimationController =
//       AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 500),
//   );

//   late final Animation<double> _lengthAnimation =
//       Tween<double>(begin: 0, end: widget.barLength)
//           .animate(_progressAnimationController);

//   @override
//   void initState() {
//     super.initState();
//     if (widget.progressValue == widget.barLength) {
//       _progressAnimationController.forward(from: widget.progressValue);
//     }
//     _progressAnimationController.addListener(() {
//       setState(() {});
//     });
//     animator();
//   }

//   @override
//   void didUpdateWidget(covariant ProgressBar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.progressValue > oldWidget.progressValue) {
//       _forwardAnimation();
//     } else if (widget.progressValue < oldWidget.progressValue) {
//       _reverseAnimation();
//     }
//   }

//   void animator() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     setState(() {
//       animate = true;
//     });
//   }

//   bool animate = false;

//   @override
//   Widget build(BuildContext context) {
//     final bool isHorizontal = widget.direction == Axis.horizontal;

//     return AnimatedContainer(
//       duration: const Duration(seconds: 1),
//       // this needs to be fixed in case of horizontal bar
//       height: animate ? widget.barLength : 0,
//       width: isHorizontal ? widget.barLength : 2,
//       margin: EdgeInsets.symmetric(
//         horizontal: isHorizontal ? 2 : 0,
//         vertical: isHorizontal ? 0 : 2,
//       ),
//       decoration: BoxDecoration(
//         color: widget.barColor.letIfTrue(toColor) ?? Colors.grey,
//         borderRadius: BorderRadius.circular(2),
//       ),
//       child: Align(
//         alignment: isHorizontal ? Alignment.centerLeft : Alignment.topLeft,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           alignment: Alignment.topCenter,
//           height: isHorizontal ? null : _lengthAnimation.value,
//           width: isHorizontal ? _lengthAnimation.value : null,
//           decoration: BoxDecoration(
//             color: widget.barColor.letIfTrue(toColor) ?? Colors.grey,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//       ),
//     );
//   }

//   void _forwardAnimation() {
//     _progressAnimationController.forward().then(
//           (_) => widget.onComplete?.call(),
//         );
//   }

//   void _reverseAnimation() {
//     _progressAnimationController.reverse().then(
//           (_) => widget.onComplete?.call(),
//         );
//   }

//   @override
//   void dispose() {
//     _progressAnimationController.dispose();
//     super.dispose();
//   }
// }

// class DZActiveStepIcon extends StatefulWidget {
//   const DZActiveStepIcon({
//     super.key,
//     this.circleColor = Colors.grey,
//   });

//   final Color circleColor;

//   @override
//   State<DZActiveStepIcon> createState() => _DZActiveStepIconState();
// }

// class _DZActiveStepIconState extends State<DZActiveStepIcon>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 1500),
//   );

//   static const double _MAX_RADIUS = 35;

//   late final Animation<double> _animation =
//       Tween<double>(begin: 0, end: _MAX_RADIUS).animate(_animationController);

//   @override
//   void initState() {
//     super.initState();
//     _animationController
//       ..forward()
//       ..repeat();
//     _animationController.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: 5,
//       backgroundColor: widget.circleColor,
//       child: OverflowBox(
//         maxHeight: _MAX_RADIUS,
//         maxWidth: _MAX_RADIUS,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 100),
//           curve: Curves.fastLinearToSlowEaseIn,
//           height: _animation.value,
//           width: _animation.value,
//           decoration: BoxDecoration(
//             color: widget.circleColor
//                 .withOpacity(1 - (_animation.value / _MAX_RADIUS)),
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

// class DZStepIcon {
//   final Widget? activeIcon;
//   final Widget? inactiveIcon;
//   final Widget? completedIcon;

//   const DZStepIcon({
//     this.activeIcon,
//     this.inactiveIcon,
//     this.completedIcon,
//   });
// }

/*

   if (index < (_titlesLength - 1)) {
        return Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildStepIcon(isCompleted),
                  ),
                  Expanded(
                    child: Container(
                      height: 4,
                      width: 10,
                      color: DZColors.accentSeaGreen,
                    ),
                  )
                ],
              ),
              DZText(
                title,
                style: DZTextStyle.label3,
                maxLines: 1,
              ),
            ],
          ),
        );
      } else {
        return Column(
          children: [
            _buildStepIcon(isCompleted),
            DZText(
              title,
              style: DZTextStyle.label3,
              maxLines: 1,
            ),
          ],
        );
      }

*/
