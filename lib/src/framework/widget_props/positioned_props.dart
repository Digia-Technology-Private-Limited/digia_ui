import '../models/types.dart';

class PositionedProps {
  final ExprOr<List<dynamic>>? expr;
  final ExprOr<double>? top;
  final ExprOr<double>? bottom;
  final ExprOr<double>? left;
  final ExprOr<double>? right;
  final ExprOr<double>? width;
  final ExprOr<double>? height;

  PositionedProps({
    this.expr,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
  });

  factory PositionedProps.fromJson(Object? data) {
    if (data == null) return PositionedProps();

    if (data is String && data.contains('js.eval')) {
      return PositionedProps(
        expr: ExprOr.fromJson({'expr': data}),
      );
    }

    if (data is String) {
      final cleaned = data.replaceAll('\${', '').replaceAll('}', '').trim();

      final parts = cleaned.split(',');

      ExprOr<double>? part(String s) {
        s = s.trim();
        if (s.isEmpty || s == '-') return null;

        final d = double.tryParse(s);
        return d != null ? ExprOr.fromJson(d) : ExprOr.fromJson({'expr': s});
      }

      return PositionedProps(
        left: parts.isNotEmpty ? part(parts[0]) : null,
        top: parts.length > 1 ? part(parts[1]) : null,
        right: parts.length > 2 ? part(parts[2]) : null,
        bottom: parts.length > 3 ? part(parts[3]) : null,
      );
    }

    return PositionedProps();
  }
}
