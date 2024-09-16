import 'props.dart';
import 'vw_repeat_data.dart';

class VWNodeData {
  final String category;
  final String type;
  final Props props;
  final Props? commonProps;
  final Map<String, List<VWNodeData>>? childGroups;
  final VWRepeatData? repeatData;
  final String? refName;

  VWNodeData({
    required this.category,
    required this.type,
    required this.props,
    required this.commonProps,
    required this.childGroups,
    required this.repeatData,
    required this.refName,
  });
}
