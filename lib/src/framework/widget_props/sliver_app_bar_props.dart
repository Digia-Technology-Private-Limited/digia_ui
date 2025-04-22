import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class SliverAppBarProps {
  final String? bottomPreferredWidth;
  final String? bottomPreferredHeight;
  final ExprOr<String>? collapsedHeight;
  final ExprOr<String>? expandedHeight;
  final String? backgroundColor;
  final double? leadingWidth;
  final double? titleSpacing;
  final bool? pinned;
  final bool? snap;
  final bool? floating;

  const SliverAppBarProps({
    this.bottomPreferredWidth,
    this.bottomPreferredHeight,
    this.collapsedHeight,
    this.expandedHeight,
    this.backgroundColor,
    this.leadingWidth,
    this.titleSpacing,
    this.pinned,
    this.snap,
    this.floating,
  });

  factory SliverAppBarProps.fromJson(JsonLike json) {
    return SliverAppBarProps(
      bottomPreferredWidth: as$<String>(json['bottomPreferredWidth']),
      bottomPreferredHeight: as$<String>(json['bottomPreferredHeight']),
      collapsedHeight: ExprOr.fromJson<String>(json['collapsedHeight']),
      expandedHeight: ExprOr.fromJson<String>(json['expandedHeight']),
      backgroundColor: as$<String>(json['backgroundColor']),
      leadingWidth: as$<double>(json['leadingWidth']),
      titleSpacing: as$<double>(json['titleSpacing']),
      snap: as$<bool>(json['snap']),
      pinned: as$<bool>(json['pinned']),
      floating: as$<bool>(json['floating']),
    );
  }
}
