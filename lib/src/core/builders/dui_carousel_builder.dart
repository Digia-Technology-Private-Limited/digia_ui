import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../components/carousel/carousel.dart';
import '../../components/carousel/carousel_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
