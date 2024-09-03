import 'package:copy_with_extension/copy_with_extension.dart';
import 'dui_component_props.dart';

part 'dui_component_state.g.dart';

@CopyWith()
class DUIComponentState {
  final String componentUid;
  DUIComponentProps props;
  bool isLoading;
  Map<String, dynamic>? componentArgs;
  Map<String, Map<String, Function>> widgetVars;

  DUIComponentState({
    required this.componentUid,
    required this.props,
    this.componentArgs,
    this.isLoading = false,
    required this.widgetVars,
  });
}
