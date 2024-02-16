import 'package:digia_ui/components/carousel/carousel.dart';
import 'package:digia_ui/components/carousel/carousel_props.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUICarouselBuilder extends DUIWidgetBuilder {
  DUICarouselBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);
  static DUICarouselBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUICarouselBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    return DUICarousel(
      DUICarouselProps.fromJson(data.props),
      data,
      registry: registry,
    );
  }
}
