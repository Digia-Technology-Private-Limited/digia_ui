abstract class DUIAnalytics {
  void onClick(String widgetName, String pageName, dynamic metaData);
  void onPageLoad(String pageName, dynamic metaData, dynamic perfData);
  // void onWidgetLoad(
  //     String widgetName, String pageName, dynamic metaData, dynamic perfData);
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
