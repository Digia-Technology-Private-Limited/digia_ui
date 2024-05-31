abstract class DUIAnalytics {
  void onEvent(List<Map<String, dynamic>> metaData);
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
