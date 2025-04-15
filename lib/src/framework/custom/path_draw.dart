import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

class PathDraw {
  static Path createDottedPath(Path path, double radius) {
    final Path dottedPath = Path();
    final double dashWidth = radius * 2; // Each dot's diameter
    final double dashSpacing = radius * 4; // Space between dots

    // Iterate over the entire path and add circular dots
    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;

      while (distance < pathMetric.length) {
        final Tangent? tangent = pathMetric.getTangentForOffset(distance);

        if (tangent != null) {
          // Add a circular dot at the current tangent position
          dottedPath.addOval(Rect.fromCircle(
            center: tangent.position,
            radius: dashWidth / 2,
          ));
        }

        // Move the distance forward by the width of the dot + the spacing
        distance += dashWidth + dashSpacing;
      }
    }

    return dottedPath;
  }

  static Path createDashedPath(Path path, List<double> dashPattern) {
    return dashPath(path, dashArray: CircularIntervalList(dashPattern));
  }
}
