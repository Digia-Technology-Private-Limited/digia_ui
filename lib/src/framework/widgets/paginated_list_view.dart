// import 'package:digia_expr/digia_expr.dart';
// import 'package:flutter/widgets.dart';

// import '../../../digia_ui.dart';
// import '../../Utils/basic_shared_utils/dui_decoder.dart';
// import '../../Utils/basic_shared_utils/num_decoder.dart';
// import '../../Utils/extensions.dart';
// import '../../core/action/api_handler.dart';
// import '../base/extensions.dart';
// import '../base/virtual_stateless_widget.dart';
// import '../internal_widgets/internal_paginated_list_view.dart';
// import '../render_payload.dart';


// class VWPaginatedListView extends VirtualStatelessWidget {
//   VWPaginatedListView({
//     required super.props,
//     required super.commonProps,
//     required super.childGroups,
//     required super.parent,
//     super.refName,
//     required super.repeatData,
//   });

//   bool get shouldRepeatChild => repeatData != null;

//   @override
//   Widget render(RenderPayload payload) {
//     if (children == null || children!.isEmpty) return empty();

//     final initialScrollPosition =
//         payload.eval<String>(props.getString('initialScrollPosition'));
//     final isReverse = payload.eval<bool>(props.getBool('reverse'));

//     if (shouldRepeatChild) {
//       final childToRepeat = children!.first;
//       final items = payload.evalRepeatData(repeatData!);

//       return InternalPaginatedListView(
//         firstPageLoadingWidget:
//             childOf('firstPageLoadingWidget')?.toWidget(payload),
//         newpageLoadingWidget:
//             childOf('newPageLoadingWidget')?.toWidget(payload),
//         pageErrorWidget: childOf('pageErrorWidget')?.toWidget(payload),
//         initialScrollPosition: initialScrollPosition ?? 'start',
//         isReverse: isReverse,
//         scrollDirection: DUIDecoder.toAxis(props.get('scrollDirection'),
//             defaultValue: Axis.vertical),
//         physics: DUIDecoder.toScrollPhysics(props.get('allowScroll')),
//         shrinkWrap: NumDecoder.toBoolOrDefault(props.get('shrinkWrap'),
//             defaultValue: false),
//         itemBuilder: (buildContext, index) => childToRepeat.toWidget(
//           payload.copyWithChainedContext(
//             _createExprContext(items[index], index),
//           ),
//         ),
//         apiRequestHandler: (pageKey, controller) {
//           final apiDataSourceId =
//               props.value.valueFor(keyPath: 'dataSource.id');
//           Map<String, dynamic>? apiDataSourceArgs =
//               props.value.valueFor(keyPath: 'dataSource.args');

//           final apiModel =
//               (payload.buildContext.tryRead<DUIPageBloc>()?.config ??
//                       DigiaUIClient.getConfigResolver())
//                   .getApiDataSource(apiDataSourceId);

//           final args = apiDataSourceArgs?.map((key, value) {
//             final evalue = eval(value,
//                 context: context,
//                 enclosing: ExprContext(variables: {'offset': pageKey}));
//             final dvalue = apiModel.variables?[key]?.defaultValue;
//             return MapEntry(key, evalue ?? dvalue);
//           });

//           ApiHandler.instance
//               .execute(apiModel: apiModel, args: args)
//               .then((resp) {
//             final response = {
//               'body': resp.data,
//               'statusCode': resp.statusCode,
//               'headers': resp.headers,
//               'requestObj': requestObjToMap(resp.requestOptions),
//               'error': null,
//             };

//             final newItems =
//                 ifNotNull(widget.data.props['newItemsTransformation'], (p0) {
//                       return eval<List>(p0,
//                           context: context,
//                           enclosing:
//                               ExprContext(variables: {'response': response}));
//                     }) ??
//                     response['body'];

//             if (newItems == null || newItems is! List || newItems.isEmpty) {
//               controller.appendLastPage([]);
//             } else {
//               controller.appendPage(newItems.cast<Object>(), pageKey + 1);
//             }
//           });
//         },
//       );
//     }

//     return InternalPaginatedListView(
//       children: children?.toWidgetArray(payload) ?? [],
//     );
//   }

//   ExprContext _createExprContext(Object? item, int index) {
//     return ExprContext(variables: {
//       'currentItem': item,
//       'index': index
//       // TODO: Add class instance using refName
//     });
//   }
// }
