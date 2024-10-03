import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class FilePickerAction extends Action {
  final String? fileType;
  final ExprOr<double>? sizeLimit;
  final bool? showToast;
  final bool? rebuildPage;
  final String? selectedPageState;
  final bool? isMultiSelected;

  FilePickerAction({
    this.fileType,
    this.sizeLimit,
    this.showToast,
    this.rebuildPage,
    this.selectedPageState,
    this.isMultiSelected,
  });

  @override
  ActionType get actionType => ActionType.callRestApi;

  factory FilePickerAction.fromJson(Map<String, Object?> json) {
    return FilePickerAction(
      fileType: as$<String>(json['fileType']),
      sizeLimit: ExprOr.fromJson<double>(json['sizeLimit']),
      showToast: as$<bool>(json['showToast']),
      rebuildPage: as$<bool>(json['rebuildPage']),
      isMultiSelected: as$<bool>(json['isMultiSelected']),
      selectedPageState: as$<String>(json['fileType']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'dataSourceId': apiId,
      'args': args,
      'successCondition': sizeLimit?.toJson(),
      'onSuccess': onSuccess?.toJson(),
      'onError': onError?.toJson(),
    };
  }
}
