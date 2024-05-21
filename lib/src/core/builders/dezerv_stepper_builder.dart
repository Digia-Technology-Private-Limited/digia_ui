// import 'package:flutter/material.dart';

// import '../../Utils/dui_widget_registry.dart';
// import '../../components/dezerv_stepper/dezerv_stepper.dart';
// import '../../components/dezerv_stepper/dezerv_stepper_props.dart';
// import '../json_widget_builder.dart';
// import '../page/props/dui_widget_json_data.dart';

// class DezervStepperBuilder extends DUIWidgetBuilder {
//   DezervStepperBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
//       : super(data: data, registry: registry);

//   static DezervStepperBuilder create(DUIWidgetJsonData data,
//       {DUIWidgetRegistry? registry}) {
//     return DezervStepperBuilder(data, registry);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (registry == null) {
//       return fallbackWidget();
//     }
//     return DezervStepper(
//       props: DezervStepperProps.fromJson(data.props),
//       data: data,
//       registry: registry,
//     );
//   }
// }
