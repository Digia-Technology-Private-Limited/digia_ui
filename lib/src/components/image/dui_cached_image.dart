import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:octo_image/octo_image.dart';

class DUICachedImage extends StatelessWidget {
  final CachedNetworkImageProvider _image;
  final Curve? fadeInCurve;
  final Curve? fadeOutCurve;
  final double? height;
  final double? width;
  final BaseCacheManager? cacheManager;
  final String imageUrl;
  final String? cacheKey;
  final Map<String, String>? httpHeaders;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Widget errorImage;
  final Widget placeHolderImage;
  final int? fadeInDuration;
  final int? fadeOutDuration;

  DUICachedImage({
    super.key,
    this.cacheManager,
    required this.imageUrl,
    this.cacheKey,
    this.httpHeaders,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.borderRadius,
    this.fit,
    required this.errorImage,
    this.height,
    this.width,
    required this.placeHolderImage,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.fadeInCurve,
    this.fadeOutCurve,
  }) : _image = CachedNetworkImageProvider(
          imageUrl,
          headers: httpHeaders,
          cacheManager: cacheManager,
          cacheKey: cacheKey,
          maxWidth: maxWidthDiskCache,
          maxHeight: maxHeightDiskCache,
        );

  static Future evictFromCache(
    String url, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
    double scale = 1.0,
  }) async {
    cacheManager = cacheManager ?? DefaultCacheManager();
    await cacheManager.removeFile(cacheKey ?? url);
    return CachedNetworkImageProvider(url, scale: scale).evict();
  }

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      height: height,
      width: width,
      gaplessPlayback: true,
      fit: fit,
      image: _image,
      fadeInDuration: fadeInDuration != null
          ? Duration(milliseconds: fadeInDuration!)
          : Duration.zero,
      fadeOutDuration: fadeOutDuration != null
          ? Duration(milliseconds: fadeOutDuration!)
          : Duration.zero,
      imageBuilder: (BuildContext context, provider) {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          clipBehavior: Clip.antiAlias,
          child: provider,
        );
      },
      errorBuilder: (context, url, error) {
        return errorImage;
      },
      placeholderBuilder: (context) {
        return placeHolderImage;
      },
    );
  }
}
