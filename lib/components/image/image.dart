import 'package:cached_network_image/cached_network_image.dart';
import 'package:digia_ui/components/image/cached_image_wrapper.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';

class DUIImage extends StatefulWidget {
  final DUIImageProps props;

  const DUIImage(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIImageState();
}

class _DUIImageState extends State<DUIImage> {
  late DUIImageProps props;

  _DUIImageState();

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  OctoPlaceholderBuilder? _placeHolderBuilderCreater() {
    final placeHolderValue = props.placeHolder;

    if (placeHolderValue == null || placeHolderValue.isEmpty) {
      return (context) {
        return props.aspectRatio != null
            ? AspectRatio(aspectRatio: props.aspectRatio!)
            : SizedBox(
                width: double.tryParse(props.styleClass?.width ?? '0.0'),
                height: double.tryParse(props.styleClass?.height ?? '0.0'),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
      };
    }

    switch (props.imageSrc.split('/').first) {
      case 'http':
      case 'https':
        return ((context) => props.aspectRatio != null
            ? AspectRatio(aspectRatio: props.aspectRatio!)
            : SizedBox(
                width: _getDimension(context, props.styleClass?.width),
                height: _getDimension(context, props.styleClass?.height),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
      case 'assets':
        return ((context) => Image.asset(placeHolderValue));
      case 'blurHash':
        return OctoPlaceholder.frame(); // [TODO] : This had been changed
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // final ImageProvider imageProvider;
    // // Network Image
    // if (props.imageSrc.startsWith('http')) {
    //   imageProvider = CachedNetworkImageProvider(props.imageSrc);
    // } else {
    //   imageProvider = AssetImage(props.imageSrc);
    // }

    Widget imageWidget = OctoImage(
        image: DUIImageProvider(source: props.imageSrc).provider,
        fit: DUIDecoder.toBoxFit(props.fit),
        gaplessPlayback: true,
        placeholderBuilder: _placeHolderBuilderCreater(),
        imageBuilder: (BuildContext context, Widget widget) {
          // final child = props.aspectRatio == null
          //     ? widget
          //     : AspectRatio(aspectRatio: props.aspectRatio!, child: widget);
          return props.styleClass != null
              ? DUIContainer(styleClass: props.styleClass, child: widget)
              : widget;
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('____---------------______');
          debugPrint('Error: ${error.toString()}');
          debugPrint('Stacktrace: ${stackTrace.toString()}');
          debugPrint('____---------------______');
          if (props.errorImage == null) {
            return Tooltip(
              verticalOffset: -18,
              margin: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.04),
              preferBelow: false,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: ShapeDecoration(
                  color: const Color(0xFF32324D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  )),
              richMessage: TextSpan(
                text: 'This Image has ',
                children: [
                  TextSpan(
                    text: 'CORS Error',
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Uri uri = Uri.parse(
                          "https://www.telerik.com/blogs/all-you-need-to-know-cors-errors#:~:text=CORS%20errors%20happen%20when%20a,by%20the%20server's%20CORS%20configuration.",
                        );
                        bool canLaunch = await canLaunchUrl(
                          uri,
                        );
                        if (canLaunch) {
                          launchUrl(uri, mode: LaunchMode.platformDefault);
                        }
                        // Single tapped.
                      },
                  ),
                  const TextSpan(
                    text: '. It may load in mobile version',
                  ),
                ],
              ),
              child: const Icon(
                Icons.error,
              ),
            );
          }
          return Image.asset(props.errorImage!);
        });

    return props.aspectRatio != null
        ? AspectRatio(
            aspectRatio: props.aspectRatio!,
            child: imageWidget,
          )
        : imageWidget;
  }

  double? _getDimension(BuildContext context, String? heightStringValue) {
    if (heightStringValue == null || heightStringValue.isEmpty == true) {
      return null;
    }

    final parsedValue = double.tryParse(heightStringValue);
    if (parsedValue != null) return parsedValue;

    if (heightStringValue.characters.last == '%') {
      final substring =
          heightStringValue.substring(0, heightStringValue.length - 1);
      final heightFactor = double.tryParse(substring);
      if (heightFactor == null) return null;

      return MediaQuery.of(context).size.height * (heightFactor / 100);
    }

    return null;
  }
}
