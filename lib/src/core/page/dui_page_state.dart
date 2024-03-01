import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:digia_ui/src/core/page/props/dui_page_props.dart';

part 'dui_page_state.g.dart';

@CopyWith()
class DUIPageState {
  final String uid;
  DUIPageProps? props;
  bool isLoading;

  DUIPageState({
    required this.uid,
    this.props,
    this.isLoading = false,
  });
}

class DUIPageInitData {
  // This is unique & might be 'slug' for now.
  String identifier;
  Map<String, dynamic> config;

  DUIPageInitData({required this.identifier, required this.config});
}
