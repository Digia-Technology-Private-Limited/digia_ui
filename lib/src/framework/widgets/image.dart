import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_image.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/widget_util.dart';

class VWImage extends VirtualLeafStatelessWidget<Props> {
  VWImage({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  VWImage.fromValues({
    required String? imageSrc,
    String? imageFit,
  }) : this(
            props: Props({
              'imageSrc': imageSrc,
              'fit': imageFit,
            }),
            commonProps: null,
            parent: null);

  Widget _mayWrapInAspectRatio(Widget child) =>
      wrapInAspectRatio(value: props.get('aspectRatio'), child: child);

  @override
  Widget render(RenderPayload payload) {
    final imageSourceExpr = props.get('src.imageSrc') ?? props.get('imageSrc');
    final imageType = props.getString('imageType');
    final fit = To.boxFit(props.get('fit'));
    final alignment = To.alignment(props.get('alignment'));
    final svgColor = payload.evalColor(props.get('svgColor'));
    final placeholderType = props.getString('placeholder');
    final placeholderSrc = props.getString('placeholderSrc');
    final errorImage = props.get('errorImage');

    return _mayWrapInAspectRatio(
      InternalImage(
        imageSourceExpr: imageSourceExpr,
        payload: payload,
        imageType: imageType,
        fit: fit,
        alignment: alignment,
        svgColor: svgColor,
        placeholderType: placeholderType,
        placeholderSrc: placeholderSrc,
        errorImage: errorImage,
      ),
    );
  }
}
