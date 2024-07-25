class AnalyticEvent {
  final String name;
  final Map<String, dynamic>? payload;
  const AnalyticEvent({
    required this.name,
    required this.payload,
  });

  factory AnalyticEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticEvent(
        name: json['name'] as String,
        payload: json['payload'] as Map<String, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'paylaod': payload};
  }
}

abstract class DUIAnalytics {
  void onEvent(List<AnalyticEvent> events);
  void onDataSourceSuccess(
      String dataSourceType, String source, dynamic metaData, dynamic perfData);
  void onDataSourceError(
      String dataSourceType, String source, DataSourceErrorInfo errorInfo);
}

abstract class DataSourceErrorInfo {
  dynamic data;
  dynamic requestOptions;
  int? statusCode;
  String? message;
  dynamic error;
  DataSourceErrorInfo(this.data, this.requestOptions, this.statusCode,
      this.error, this.message);
}

class ApiServerInfo extends DataSourceErrorInfo {
  ApiServerInfo(super.data, super.requestOptions, super.statusCode, super.error,
      super.message);
}
