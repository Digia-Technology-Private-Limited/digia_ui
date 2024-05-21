// import 'package:dezerv_ui/dezerv_ui.dart';
// import 'package:dezerv_ui/src/utils/constants.dart';
// import 'package:dezerv_ui/src/utils/utils.dart';
// import 'package:flutter/material.dart';

// const double _V_TEXT_LEFT_PADDING = 32;
// const double _V_TEXT_BOTTOM_PADDING = 32;
// const double _V_TEXT_IN_BETWEEN_PADDING = 4;
// const double _MAX_PROGRESS_LENGTH = 300;
// // const double _STEP_RADIUS = 10;
// // const double _STEP_DIMENSION = _STEP_RADIUS * 2;

// class DZStepper extends StatefulWidget {
//   const DZStepper({
//     super.key,
//     // required this.completedIndex,
//     required this.currentIndex,
//     this.direction = Axis.horizontal,
//     required this.steps,
//     this.showActiveState = false,
//     this.sidePadding = 40,
//     this.iconRadius = 10,
//   });

//   // final int completedIndex;
//   final int currentIndex;
//   final Axis direction;
//   final List<DZStep> steps;
//   final bool showActiveState;

//   /// [sidePadding] is required in horizontal direction so can calculate height of text
//   final double sidePadding;
//   final double iconRadius;

//   @override
//   State<DZStepper> createState() => _DZStepperState();
// }

// class _DZStepperState extends State<DZStepper> {
//   int get _stepsLength => widget.steps.length;
//   int get _stepIndex => widget.currentIndex /* ?? widget.completedIndex */;
//   late int _stepCircleIndex = _stepIndex;
//   late final double _stepDimension = widget.iconRadius * 2;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: widget.direction == Axis.horizontal
//           ? _buildHorizontalStepper()
//           : _buildVerticalStepper(),
//     );
//   }

//   Widget _buildHorizontalStepper() {
//     List<Widget> buildSteps = [];
//     List<Widget> buildTitles = [];

//     for (int index = 0; index < _stepsLength; index++) {
//       buildSteps.add(_buildStepIcon(index));
//       if (index < (_stepsLength - 1)) {
//         buildSteps.add(
//           Expanded(
//             child: _buildProgressBar(index, _MAX_PROGRESS_LENGTH),
//           ),
//         );
//       }

//       buildTitles.add(widget.steps[index].title);
//     }

//     return Column(
//       children: [
//         Padding(
//           padding: _getHorizontalPadding(),
//           child: Row(
//             children: buildSteps,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: buildTitles,
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalStepper() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(
//         _stepsLength,
//         (int index) => _buildVerticalStep(index),
//       ),
//     );
//   }

//   Widget _buildVerticalStep(int index) {
//     final DZStep dzStep = widget.steps[index];
//     final bool isCompleted =
//         widget.showActiveState ? index < _stepIndex : index <= _stepCircleIndex;

//     double itemLength = _getContentHeight(dzStep.title, dzStep.subtitle);
//     // When it's small animated icon
//     if (widget.showActiveState && !isCompleted) {
//       itemLength -= widget.iconRadius;
//     } else {
//       itemLength -= _stepDimension;
//     }

//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: _V_TEXT_LEFT_PADDING),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               dzStep.title,
//               if (dzStep.subtitle != null) ...{
//                 const SizedBox(height: _V_TEXT_IN_BETWEEN_PADDING),
//                 dzStep.subtitle!,
//               },
//               if (index < _stepsLength - 1)
//                 const SizedBox(height: _V_TEXT_BOTTOM_PADDING)
//             ],
//           ),
//         ),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildStepIcon(index),
//             if (index < (_stepsLength - 1))
//               _buildProgressBar(index, itemLength),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStepIcon(int index) {
//     final bool isActive = index <= _stepCircleIndex;
//     final bool isCompleted =
//         widget.showActiveState ? index < _stepIndex : index <= _stepCircleIndex;

//     final DZStepIcon? dzStepIcon = widget.steps[index].stepIcon;
//     final Widget? stepIcon;

//     if (widget.showActiveState && index == widget.currentIndex && isActive) {
//       stepIcon = dzStepIcon?.activeIcon ??
//           DZActiveStepIcon(
//             circleColor: widget.direction == Axis.horizontal
//                 ? DZColors.accentSeaGreen
//                 : DZColors.foreground50,
//           );
//     } else {
//       // Inactive state
//       if (widget.showActiveState && !isCompleted) {
//         stepIcon = dzStepIcon?.inactiveIcon ??
//             Container(
//               height: widget.iconRadius,
//               width: widget.iconRadius,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: DZColors.foreground30,
//                   width: 2,
//                 ),
//               ),
//             );
//       } else if (isCompleted) {
//         stepIcon = dzStepIcon?.completedIcon;
//       } else {
//         stepIcon = dzStepIcon?.inactiveIcon;
//       }
//     }

//     return SizedBox(
//       width: widget.direction == Axis.vertical ? _stepDimension : null,
//       height: widget.direction == Axis.horizontal ? _stepDimension : null,
//       child: stepIcon ??
//           CircleAvatar(
//             radius: widget.iconRadius,
//             backgroundColor:
//                 isCompleted ? DZColors.accentSeaGreen : DZColors.foreground30,
//             child: isCompleted
//                 ? const ImageIcon(
//                     AssetImage(
//                       "$kAssetsIcons/ic_check_mark_fat.png",
//                     ),
//                     color: DZColors.background,
//                     size: 8,
//                   )
//                 : null,
//           ),
//     );
//   }

//   Widget _buildProgressBar(int index, double itemLength) {
//     return ProgressBar(
//       progressValue: index < widget.currentIndex ? itemLength : 0,
//       barLength: itemLength,
//       direction: widget.direction,
//       onComplete: () {
//         setState(() {
//           _stepCircleIndex = widget.currentIndex;
//         });
//       },
//     );
//   }

// // Gets first and last title height to adjust and center title in horizontal stepper
//   EdgeInsets _getHorizontalPadding() {
//     final double firstTitleWidth = getTextSize(
//       context: context,
//       dzText: widget.steps.first.title,
//     ).width;
//     final double lastTitleWidth = getTextSize(
//       context: context,
//       dzText: widget.steps.last.title,
//     ).width;
//     // Divider the title width by 2 to half it and remove step circle radius
//     return EdgeInsets.only(
//         left: (firstTitleWidth / 2) - widget.iconRadius,
//         right: (lastTitleWidth / 2) - widget.iconRadius);
//   }

//   double _getContentHeight(DZText title, DZHtmlText? subTitle) {
//     final double titleHeight = getTextHeight(
//       context: context,
//       text: title.text,
//       textStyle: title.style.style,
//       widthToRemove: widget.sidePadding + _V_TEXT_LEFT_PADDING,
//     );

//     double subTitleHeight = 0;
//     if (subTitle != null) {
//       subTitleHeight = _V_TEXT_IN_BETWEEN_PADDING;
//       subTitleHeight += getTextHeight(
//         context: context,
//         text: removeAllHtmlTags(subTitle.text),
//         textStyle: subTitle.style.style,
//         widthToRemove: widget.sidePadding + _V_TEXT_LEFT_PADDING,
//       );
//     } else {
//       subTitleHeight = 8;
//     }

//     final double itemHeight =
//         titleHeight + subTitleHeight + _V_TEXT_BOTTOM_PADDING;

//     return itemHeight;
//   }
// }

// class ProgressBar extends StatefulWidget {
//   final double progressValue;
//   final double barLength;
//   final Axis direction;
//   final VoidCallback? onComplete;

//   const ProgressBar({
//     super.key,
//     required this.progressValue,
//     required this.barLength,
//     this.direction = Axis.horizontal,
//     this.onComplete,
//   });

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

//   @override
//   Widget build(BuildContext context) {
//     final bool isHorizontal = widget.direction == Axis.horizontal;

//     return Container(
//       height: isHorizontal ? 2 : widget.barLength,
//       width: isHorizontal ? widget.barLength : 2,
//       margin: EdgeInsets.symmetric(
//         horizontal: isHorizontal ? 2 : 0,
//         vertical: isHorizontal ? 0 : 2,
//       ),
//       decoration: BoxDecoration(
//         color: DZColors.foreground16,
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
//             color: DZColors.accentSeaGreen,
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
//     this.circleColor = DZColors.accentSeaGreen,
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

// class DZStep {
//   final DZText title;
//   final DZHtmlText? subtitle;
//   final DZStepIcon? stepIcon;

//   const DZStep({
//     required this.title,
//     this.subtitle,
//     this.stepIcon,
//   });
// }

// /*

//    if (index < (_titlesLength - 1)) {
//         return Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2),
//                     child: _buildStepIcon(isCompleted),
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 4,
//                       width: 10,
//                       color: DZColors.accentSeaGreen,
//                     ),
//                   )
//                 ],
//               ),
//               DZText(
//                 title,
//                 style: DZTextStyle.label3,
//                 maxLines: 1,
//               ),
//             ],
//           ),
//         );
//       } else {
//         return Column(
//           children: [
//             _buildStepIcon(isCompleted),
//             DZText(
//               title,
//               style: DZTextStyle.label3,
//               maxLines: 1,
//             ),
//           ],
//         );
//       }


// */