import 'package:copy_with_extension/copy_with_extension.dart';
import 'props/dui_page_props.dart';

part 'dui_page_state.g.dart';

@CopyWith()
class DUIPageState {
  final String pageUid;
  DUIPageProps props;
  bool isLoading;
  Object? dataSource;
  Map<String, dynamic>? pageArgs;

  DUIPageState({
    required this.pageUid,
    required this.props,
    this.pageArgs,
    this.isLoading = false,
    this.dataSource,
  });
}
