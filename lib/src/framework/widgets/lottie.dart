import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../digia_ui_client.dart';
import '../../dui_dev_config.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWLottie extends VirtualLeafStatelessWidget<Props> {
  VWLottie({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final (repeat, reverse) =
        getAnimationType(props.getString('animationType'));
    final alignment = To.alignment(props.get('alignment'));
    final height = props.getDouble('height');
    final width = props.getDouble('width');
    final animate = payload.eval<bool>(props.get('animate')) ?? true;
    final frameRate = FrameRate(props.getDouble('frameRate') ?? 60);
    final fit = To.boxFit(props.get('fit'));

    final lottiePath = payload.eval<String>(props.get('lottiePath'));

    if (lottiePath == null) {
      return const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }

    Widget errorBuilder(
        BuildContext context, Object object, StackTrace? stackTrace) {
      return SizedBox(
        height: height,
        width: width,
        child: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }

    if (lottiePath.startsWith('http')) {
      final DigiaUIHost? host = DigiaUIClient.instance.developerConfig?.host;
      final String finalUrl;
      if (host is DashboardHost && host.resourceProxyUrl != null) {
        finalUrl = '${host.resourceProxyUrl}${Uri.encodeFull(lottiePath)}';
      } else {
        finalUrl = lottiePath;
      }
      return LottieBuilder.network(
        finalUrl,
        alignment: alignment,
        height: height,
        width: width,
        animate: animate,
        frameRate: frameRate,
        fit: fit,
        repeat: repeat,
        reverse: reverse,
        errorBuilder: errorBuilder,
      );
    }

    return LottieBuilder.asset(
      lottiePath,
      alignment: alignment,
      height: height,
      width: width,
      animate: animate,
      frameRate: frameRate,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      errorBuilder: errorBuilder,
    );
  }

  (bool repeat, bool reverse) getAnimationType(String? animationType) {
    final value = animationType ?? 'loop';

    switch (value) {
      case 'boomerang':
        return (true, true);
      case 'once':
        return (false, false);
      case 'loop':
      default:
        return (true, false);
    }
  }
}
