import '../utils/object_util.dart';
import '../utils/types.dart';

class PositionedProps {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;

  PositionedProps({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
  });

  factory PositionedProps.fromJson(Object? data) {
    if (data is String) {
      double? parse(String v) {
        v = v.trim();
        return (v.isEmpty || v == '-') ? null : v.to<double>();
      }

      final parts = data.split(',');
      return PositionedProps(
        left: parts.isNotEmpty ? parse(parts[0]) : null,
        top: parts.length > 1 ? parse(parts[1]) : null,
        right: parts.length > 2 ? parse(parts[2]) : null,
        bottom: parts.length > 3 ? parse(parts[3]) : null,
      );
    }

    if (data is JsonLike) {
      return PositionedProps(
        top: data['top']?.to<double>(),
        bottom: data['bottom']?.to<double>(),
        left: data['left']?.to<double>(),
        right: data['right']?.to<double>(),
        width: data['width']?.to<double>(),
        height: data['height']?.to<double>(),
      );
    }

    return PositionedProps();
  }
}