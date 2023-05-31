class PageInitData {
  String pageName;
  Map<String, dynamic> pageConfig;
  Map<String, dynamic>? inputArgs;

  PageInitData(
      {required this.pageName, required this.pageConfig, this.inputArgs});
}
