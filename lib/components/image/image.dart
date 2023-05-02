import 'dart:io';

import 'package:digia_ui/Utils/constants/constants.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DUIImage extends StatefulWidget {
  final DUIImageProps props;

  const DUIImage(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIImageState();
}

class _DUIImageState extends State<DUIImage> {
  late DUIImageProps props;
  late File _file;

  _DUIImageState();

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  Future<File> _cacheImage() async {
    final cacheDir = await getTemporaryDirectory();
    String filePath = "${cacheDir.path}/${widget.props.imageSrc.hashCode}";

    final file = File(filePath);
    if (!file.existsSync()) {
      final request =
          await HttpClient().getUrl(Uri.parse(widget.props.imageSrc));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  Widget errorImage() => Image.asset(
        kDUIErrorImage,
        height: props.height,
        width: props.width,
        fit: props.fit.fitImage(),
      );

  Widget placeHolderImage() => Image.asset(
        kDUIPlaceHolder,
        height: props.height,
        width: props.width,
        fit: props.fit.fitImage(),
      );

  Widget imageWidget() => ClipRRect(
      borderRadius: props.cornerRadius?.getRadius(),
      clipBehavior: Clip.hardEdge,
      child: props.imageSrc.split('/').first == 'assets'
          ? Image.asset(
              props.imageSrc,
              height: props.height,
              width: props.width,
              fit: props.fit.fitImage(),
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return errorImage();
              },
            )
          : Image.network(
              props.imageSrc,
              height: props.height,
              width: props.width,
              fit: props.fit.fitImage(),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return placeHolderImage();
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return errorImage();
              },
            ));

  @override
  Widget build(BuildContext context) {
    return props.margins != null
        ? Container(
            margin: props.margins!.margins(),
            padding: props.margins!.margins(),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.rectangle,
                borderRadius: props.cornerRadius?.getRadius()),
            height: props.height,
            width: props.width,
            child: imageWidget(),
          )
        : imageWidget();
  }
}
