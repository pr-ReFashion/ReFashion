import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageView extends StatelessWidget {
  final BoxFit fit;
  final String imagePath;
  final Color? color;
  final double? height;
  final double? width;
  final double? size;
  final String? errorImage;
  final double? errorHeight;
  final double? errorWidth;

  /// Localhost prefix that the backend may return in image URLs.
  static const String _localhostPrefix = 'http://localhost:9000';

  const CachedImageView({
    super.key,
    required this.imagePath,
    this.color,
    this.height,
    this.fit = BoxFit.contain,
    this.width,
    this.size,
    this.errorImage,
    this.errorHeight,
    this.errorWidth,
  });

  /// Replaces `http://localhost:9000` prefix with [ApiConfig.baseUrl]
  /// so that images resolve to the correct remote server.
  static String resolveImageUrl(String url) {
    if (url.startsWith(_localhostPrefix)) {
      return url.replaceFirst(_localhostPrefix, ApiConfig.baseUrl);
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedPath = resolveImageUrl(imagePath);
    final double? resolvedHeight = size ?? height;
    final double? resolvedWidth = size ?? width;
    final double resolvedErrorHeight = (resolvedHeight ?? 20.h) / 3;
    final double resolvedErrorWidth = (resolvedWidth ?? 20.w) / 2;

    if (resolvedPath.isEmpty) {
      return Container(
        height: resolvedHeight,
        width: resolvedWidth,
        alignment: Alignment.center,
        color: ColorHelper.inputDecorationBorder,
        child: CachedImageView(
          imagePath: errorImage ?? ImageHelper.icNoImage,
          height: errorHeight ?? resolvedErrorHeight,
          width: errorWidth ?? resolvedErrorWidth,
          fit: fit,
        ),
      );
    }

    if (resolvedPath.endsWith('.svg')) {
      return SvgPicture.asset(
        fit: fit,
        resolvedPath,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        width: (size ?? width) ?? 20.w,
        height: (size ?? height) ?? 20.h,
        placeholderBuilder: (context) {
          return Shimmer.fromColors(
            baseColor: ColorHelper.white,
            highlightColor: ColorHelper.shimmerColor,
            child: SizedBox(
              height: (size ?? height),
              width: (size ?? width),
              child: Container(
                height: (size ?? height),
                width: (size ?? width),
                color: ColorHelper.shimmerColor,
              ),
            ),
          );
        },
      );
    } else if (resolvedPath.startsWith('http') ||
        resolvedPath.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: resolvedPath,
        height: resolvedHeight,
        width: resolvedWidth,
        fit: fit,
        // Add memCache to avoid OOM on large images, though main issue is corruption
        memCacheWidth: resolvedWidth != null && resolvedWidth.isFinite
            ? (resolvedWidth * 2).toInt()
            : null,
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: ColorHelper.white,
            highlightColor: ColorHelper.shimmerColor,
            child: SizedBox(
              height: resolvedHeight,
              width: resolvedWidth,
              child: Container(
                width: width,
                height: height,
                color: ColorHelper.shimmerColor,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: resolvedHeight,
            width: resolvedWidth,
            alignment: Alignment.center,
            child: CachedImageView(
              imagePath: errorImage ?? ImageHelper.icNoImage,
              height: errorHeight ?? resolvedErrorHeight,
              width: errorWidth ?? resolvedErrorWidth,
              fit: fit,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        resolvedPath,
        height: resolvedHeight,
        width: resolvedWidth,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: resolvedHeight,
            width: resolvedWidth,
            alignment: Alignment.center,
            color: ColorHelper.inputDecorationBorder,
            child: CachedImageView(
              imagePath: errorImage ?? ImageHelper.icNoImage,
              height: errorHeight ?? resolvedErrorHeight,
              width: errorWidth ?? resolvedErrorWidth,
              fit: fit,
            ),
          );
        },
      );
    }
  }
}
