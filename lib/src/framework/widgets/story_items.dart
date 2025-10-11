import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/story_item_props.dart';
import '../resource_provider.dart';
import '../../init/digia_ui_manager.dart';
import '../../dui_dev_config.dart';

class VWStoryItem extends VirtualStatelessWidget<StoryItemProps> {
  VWStoryItem({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  final loadingWidget = Container(
    color: Colors.grey[100],
    child: const Center(child: CupertinoActivityIndicator()),
  );

  String resolveAssetUrl(RenderPayload payload, String url) {
    // Case 1 : Network Url
    if (url.startsWith('http')) {
      final DigiaUIHost? host = DigiaUIManager().host;
      if (host is DashboardHost && host.resourceProxyUrl != null) {
        return '${host.resourceProxyUrl}${Uri.encodeFull(url)}';
      }
      return url;
    }

    // Case 2: Local asset
    final imageProvider =
        ResourceProvider.maybeOf(payload.buildContext)?.getImageProvider(url);

    if (imageProvider is NetworkImage) {
      return imageProvider.url;
    } else if (imageProvider is CachedNetworkImageProvider) {
      return imageProvider.url;
    }

    return url;
  }

  StoryItem? toStoryItem(
      RenderPayload payload, FlutterStoryController controller) {
    final type = props.storyItemType?.evaluate(payload.scopeContext);
    final url = props.url?.evaluate(payload.scopeContext);
    final duration = props.durationInMs?.evaluate(payload.scopeContext);
    final isMuteByDefault =
        props.isMuteByDefault?.evaluate(payload.scopeContext);

    final durationTransformed = duration != null
        ? Duration(milliseconds: duration)
        : const Duration(seconds: 3);

    if (url == null) return null;

    final resolvedUrl = resolveAssetUrl(payload, url);
    final isAsset = !url.startsWith('http');

    switch (type) {
      case 'image':
        return StoryItem(
          storyItemType: StoryItemType.image,
          url: resolvedUrl,
          storyItemSource:
              isAsset ? StoryItemSource.asset : StoryItemSource.network,
          thumbnail: loadingWidget,
          duration: durationTransformed,
          imageConfig: props.imageConfig != null
              ? StoryViewImageConfig(
                  fit: To.boxFit(
                      payload.eval(props.imageConfig?['fit']) ?? 'cover'),
                )
              : null,
        );

      case 'video':
        return StoryItem(
          storyItemType: StoryItemType.video,
          url: resolvedUrl,
          storyItemSource:
              isAsset ? StoryItemSource.asset : StoryItemSource.network,
          thumbnail: loadingWidget,
          duration: durationTransformed,
          isMuteByDefault: isMuteByDefault ?? false,
          videoConfig: props.videoConfig != null
              ? StoryViewVideoConfig(
                  fit: To.boxFit(
                      payload.eval(props.videoConfig?['fit']) ?? 'cover'),
                )
              : null,
        );

      case 'custom':
        final childWidget = child?.toWidget(payload);
        if (childWidget == null) return null;

        return StoryItem(
          storyItemType: StoryItemType.custom,
          customWidget: (context, storyController) => childWidget,
          duration: durationTransformed,
        );

      default:
        return null;
    }
  }

  @override
  Widget render(RenderPayload payload) {
    return const SizedBox.shrink();
  }
}
