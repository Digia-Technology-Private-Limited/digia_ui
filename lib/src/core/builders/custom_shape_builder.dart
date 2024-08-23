import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class CustomShapeBuilder extends DUIWidgetBuilder {
  CustomShapeBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static CustomShapeBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return CustomShapeBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    double? height = eval<double>(context: context, data.props['height']);
    double? width = eval<double>(context: context, data.props['width']);

    final double? borderRadius =
        eval<double>(data.props['borderRadius'], context: context);
    final Color? borderColor =
        makeColor(eval<String>(data.props['borderColor'], context: context));
    final Color? backgroundColor = makeColor(
        eval<String>(data.props['backgroundColor'], context: context));
    final double? strokeWidth =
        eval<double>(data.props['strokeWidth'], context: context);

    return CustomPaint(
      painter: ShapePainter(
          borderColor: borderColor ?? Colors.black,
          borderRadius: borderRadius ?? 10,
          strokeWidth: strokeWidth ?? 2),
      child: ClipPath(
        clipper: ShapeClipper(borderRadius: borderRadius ?? 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            color: backgroundColor,
          ),
          width: width,
          height: height,
          child: data.children['child']?.first.let(
            (p0) => DUIWidget(data: p0).build(context),
          ),
        ),
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  final double borderRadius;

  ShapeClipper({super.reclip, required this.borderRadius});
  @override
  Path getClip(Size size) {
    return ShapePath.getPath(size, radius: borderRadius);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ShapePainter extends CustomPainter {
  final Color borderColor;
  final double strokeWidth;
  final double borderRadius;

  ShapePainter(
      {super.repaint,
      required this.borderColor,
      required this.strokeWidth,
      required this.borderRadius});
  @override
  void paint(Canvas canvas, Size size) {
    print(size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = borderColor;

    final path = ShapePath.getPath(size, radius: borderRadius);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ShapePath {
  final double borderRadius;

  ShapePath({required this.borderRadius});
  static Path getPath(Size size, {double radius = 0}) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    path.moveTo(width - radius, 0);
    path.quadraticBezierTo(width, 0, width, radius);
    path.lineTo(width, height - radius);
    path.quadraticBezierTo(width, height, width - radius, height);
    path.lineTo(radius, height);
    path.quadraticBezierTo(0, height, 0, height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(width * 0.093, 0);
    path.quadraticBezierTo(
        width * 0.14, height * 0.001, width * 0.14, height * 0.075);
    path.quadraticBezierTo(
        width * 0.14, height * 0.155, width * 0.2, height * 0.15);
    path.lineTo(width * 0.35, height * 0.15);
    path.quadraticBezierTo(
        width * 0.4, height * 0.155, width * 0.4, height * 0.075);
    path.quadraticBezierTo(width * 0.4, height * 0.001, width * 0.45, 0);
    path.lineTo(width * 0.55, 0);
    path.quadraticBezierTo(
        width * 0.6, height * 0.001, width * 0.6, height * 0.075);
    path.quadraticBezierTo(
        width * 0.6, height * 0.155, width * 0.65, height * 0.15);
    path.lineTo(width * 0.8, height * 0.15);
    path.quadraticBezierTo(
        width * 0.87, height * 0.155, width * 0.87, height * 0.075);
    path.quadraticBezierTo(width * 0.87, height * 0.001, width * 0.907, 0);

    path.close();

    return path;
  }
}
