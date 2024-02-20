import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DUIImageProvider {
  final ImageProvider provider;

  DUIImageProvider({required String source})
      : provider = getNetworkImageProvider(source);

  static ImageProvider getNetworkImageProvider(String source) {
    if (source.contains('http')) {
      if (kIsWeb) {
        return NetworkImage(source);
      } else {
        return CachedNetworkImageProvider(source);
      }
    } else {
      return AssetImage(source);
    }
  }
}
