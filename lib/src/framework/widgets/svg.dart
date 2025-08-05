import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../digia_ui.dart';
import '../models/props.dart';
import '../utils/flutter_extensions.dart';

class VWSvgImage extends VirtualLeafStatelessWidget<Props> {
  VWSvgImage({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  SvgPicture _createSvgPicture(RenderPayload payload, Object? imageSource,
      double? width, double? height, Color? color) {
    if (imageSource is String) {
      if (imageSource.startsWith('http')) {
        final DigiaUIHost? host = DigiaUIManager().host;
        final String finalUrl;
        if (host is DashboardHost && host.resourceProxyUrl != null) {
          finalUrl = '${host.resourceProxyUrl}${Uri.encodeFull(imageSource)}';
        } else {
          finalUrl = imageSource;
        }
        return SvgPicture.network(
          finalUrl,
          width: width,
          height: height,
          colorFilter:
              ColorFilter.mode(color ?? Colors.black, BlendMode.srcATop),
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(error),
          fit: To.boxFit(props.get('fit')),
        );
      } else {
        return SvgPicture.asset(
          imageSource,
          width: width,
          height: height,
          colorFilter:
              ColorFilter.mode(color ?? Colors.black, BlendMode.srcATop),
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(error),
          fit: To.boxFit(props.get('fit')),
        );
      }
    }

    throw Exception('Unsupported image source type');
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  Widget render(RenderPayload payload) {
    final width = props.getString('width')?.toWidth(payload.buildContext);

    final height = props.getString('height')?.toHeight(payload.buildContext);
    final imageSource = payload.eval(props.get('svgSrc'));
    final color = payload.evalColor(props.get('color'));

    return _createSvgPicture(payload, imageSource, width, height, color);
  }
}
