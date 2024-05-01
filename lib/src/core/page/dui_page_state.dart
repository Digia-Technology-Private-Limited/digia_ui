import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:digia_ui/src/core/page/props/dui_page_props.dart';

part 'dui_page_state.g.dart';

@CopyWith()
class DUIPageState {
  final String pageUid;
  DUIPageProps props;
  bool isLoading;

  DUIPageState({
    required this.pageUid,
    required this.props,
    this.isLoading = false,
  });
}
