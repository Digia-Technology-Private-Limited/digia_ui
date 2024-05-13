// import 'package:flutter/material.dart';

// import '../../../digia_ui.dart';
// import '../../Utils/dui_widget_registry.dart';
// import '../../Utils/extensions.dart';
// import '../../Utils/util_functions.dart';
// import '../../components/dui_widget_scope.dart';
// import '../../components/image/image.dart';
// import '../../components/image/image.props.dart';
// import '../json_widget_builder.dart';
// import 'dui_icon_builder.dart';
// import 'dui_text_builder.dart';

// class DUIExpansionBuilder extends DUIWidgetBuilder {
//   DUIExpansionBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
//       : super(data: data, registry: registry);

//   static DUIExpansionBuilder create(DUIWidgetJsonData data,
//       {DUIWidgetRegistry? registry}) {
//     return DUIExpansionBuilder(data, registry);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (registry == null) {
//       return fallbackWidget();
//     }
//     final color =
//         eval<String>(data.props['expandedBackgroundColor']).let(toColor);
//     final collapsedBackgroundColor =
//         eval<String>(data.props['collapsedBackgroundColor']).let(toColor);
//     final collapsedBorderRadius =
//         eval<double>(data.props['collapsedBorderRadius']);
//     final collapsedBorderWidth =
//         eval<double>(data.props['collapsedBorderWidth']);
//     final collapsedBorderColor =
//         eval<String>(data.props['collapsedBorderColor']).let(toColor);
//     final expandedBorderRadius =
//         eval<double>(data.props['expandedBorderRadius']);
//     final expandedBorderWidth = eval<double>(data.props['expandedBorderWidth']);
//     final expandedBorderColor =
//         eval<String>(data.props['expandedBorderColor']).let(toColor);

//     final titleWidget = DUITextBuilder.fromProps(props: data.props['title']);

//     Widget? subtitleWidget;
//     if (data.props['subtitle'] != null) {
//       subtitleWidget = DUITextBuilder.fromProps(props: data.props['subtitle'])
//           .build(context);
//     }

//     // DUIIconBuilder? leadingWidget1 = null;
//     // if (eval<String>(data.props['leadingIcon']) != null) {
//     //   leadingWidget1 =
//     //       DUIIconBuilder.fromProps(props: data.props["leadingIcon"]);
//     // }
//     DUIImage? leadingWidget2;
//     if (eval<String>(data.props['leadingImage']) != null) {
//       leadingWidget2 =
//           DUIImage(DUIImageProps.fromJson(data.props['leadingImage']));
//     }
//     final trailingCollapsedWidget =
//         DUIIconBuilder.fromProps(props: data.props['trailingCollapsed']);
//     final trailingExpandedWidget =
//         DUIIconBuilder.fromProps(props: data.props['trailingExpanded']);
//     bool isExpanded = data.props['initiallyExpanded'] ?? false;
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter expandState) {
//         return ExpansionTile(
//           initiallyExpanded: data.props['initiallyExpanded'] ?? false,
//           title: titleWidget.build(context),
//           subtitle: (subtitleWidget != null) ? subtitleWidget : null,
//           leading: (leadingWidget2 != null) ? leadingWidget2 : null,
//           trailing: isExpanded
//               ? trailingExpandedWidget.build(context)
//               : trailingCollapsedWidget.build(context),
//           backgroundColor: color,
//           collapsedBackgroundColor: collapsedBackgroundColor,
//           collapsedShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(collapsedBorderRadius ?? 12),
//             side: BorderSide(
//               color: collapsedBorderColor ?? Colors.white,
//               width: collapsedBorderWidth ?? 1,
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(expandedBorderRadius ?? 12),
//             side: BorderSide(
//               color: expandedBorderColor ?? Colors.transparent,
//               width: expandedBorderWidth ?? 1,
//             ),
//           ),
//           onExpansionChanged: (value) {
//             expandState(
//               () {
//                 isExpanded = value;
//               },
//             );
//           },
//           children: !(data.children['children'].isNullOrEmpty)
//               ? data.children['children']!.map((e) {
//                   return DUIWidget(data: e);
//                 }).toList()
//               : [
//                   const Text(
//                     'Children field is Empty!',
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//         );
//       },
//     );
//   }

//   @override
//   Widget fallbackWidget() {
//     return const Text('Registry not found for Column');
//   }
// }
