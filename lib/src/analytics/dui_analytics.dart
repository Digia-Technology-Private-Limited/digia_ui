abstract class DUIAnalytics {
  void onClick(String widgetName, String pageName, dynamic metaData);
  void onPageLoad(String pageName, dynamic metaData, dynamic perfData);
  // void onWidgetLoad(
  //     String widgetName, String pageName, dynamic metaData, dynamic perfData);
  void onDataSourceSuccess(
      String dataSourceType, String source, dynamic metaData, dynamic perfData);
  void onDataSourceError(
      String dataSourceType, String source, dynamic metaData);
}