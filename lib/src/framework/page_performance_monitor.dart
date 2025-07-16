import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class PagePerformanceMonitor {
  static final PagePerformanceMonitor _instance =
      PagePerformanceMonitor._internal();
  factory PagePerformanceMonitor() => _instance;
  PagePerformanceMonitor._internal();

  final Map<String, PagePerformanceData> _pagePerformanceData = {};
  bool _isMonitoring = false;

  void startMonitoring() {
    _isMonitoring = true;
    print('Page Performance Monitor Started');
  }

  void stopMonitoring() {
    _isMonitoring = false;
    print('Page Performance Monitor Stopped');
  }

  void startPageLoad(String pageId, {Map<String, dynamic>? pageArgs}) {
    if (!_isMonitoring) return;

    final data = PagePerformanceData(
      pageId: pageId,
      pageArgs: pageArgs,
      startTime: DateTime.now(),
      startTimestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _pagePerformanceData[pageId] = data;

    print('Page Load Started: $pageId');
    print('Page Load Start Time: ${data.startTimestamp}');

    // Schedule FMP measurement after first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _markFirstMeaningfulPaint(pageId);
    });
  }

  void _markFirstMeaningfulPaint(String pageId) {
    if (!_isMonitoring) return;

    final data = _pagePerformanceData[pageId];
    if (data == null) return;

    final now = DateTime.now();
    data.fmpTime = now;
    data.fmpDuration = now.difference(data.startTime);

    print(
        'First Meaningful Paint: $pageId - ${data.fmpDuration!.inMilliseconds}ms');
    print('FMP Time: ${data.fmpDuration!.inMilliseconds} ms');
  }

  void markTimeToInteractive(String pageId) {
    if (!_isMonitoring) return;

    final data = _pagePerformanceData[pageId];
    if (data == null) return;

    final now = DateTime.now();
    data.ttiTime = now;
    data.ttiDuration = now.difference(data.startTime);
    data.pageLoadDuration = data.ttiDuration; // Page load ends with TTI

    print(
        'Time to Interactive: $pageId - ${data.ttiDuration!.inMilliseconds}ms');
    print(
        'Page Load Time: $pageId - ${data.pageLoadDuration!.inMilliseconds}ms');

    // Log for script parsing
    print('TTI Time: ${data.ttiDuration!.inMilliseconds} ms');
    print(
        'Page Load Complete Time: ${data.pageLoadDuration!.inMilliseconds} ms');

    _logPagePerformanceStats(pageId);
  }

  void _logPagePerformanceStats(String pageId) {
    final data = _pagePerformanceData[pageId];
    if (data == null) return;

    print('=== Page Performance Stats: $pageId ===');
    print('Start Time: ${data.startTimestamp}');
    print('FMP: ${data.fmpDuration?.inMilliseconds ?? 0}ms');
    print('TTI: ${data.ttiDuration?.inMilliseconds ?? 0}ms');
    print('Page Load: ${data.pageLoadDuration?.inMilliseconds ?? 0}ms');
    print('Page Args: ${data.pageArgs}');
    print('========================================');
  }

  PagePerformanceData? getPagePerformanceData(String pageId) {
    return _pagePerformanceData[pageId];
  }

  Map<String, PagePerformanceData> getAllPagePerformanceData() {
    return Map.unmodifiable(_pagePerformanceData);
  }

  void reset() {
    _pagePerformanceData.clear();
  }

  void clearPageData(String pageId) {
    _pagePerformanceData.remove(pageId);
  }
}

class PagePerformanceData {
  final String pageId;
  final Map<String, dynamic>? pageArgs;
  final DateTime startTime;
  final int startTimestamp;

  DateTime? fmpTime;
  Duration? fmpDuration;

  DateTime? ttiTime;
  Duration? ttiDuration;

  Duration? pageLoadDuration;

  PagePerformanceData({
    required this.pageId,
    this.pageArgs,
    required this.startTime,
    required this.startTimestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageId': pageId,
      'pageArgs': pageArgs,
      'startTimestamp': startTimestamp,
      'fmpMs': fmpDuration?.inMilliseconds,
      'ttiMs': ttiDuration?.inMilliseconds,
      'pageLoadMs': pageLoadDuration?.inMilliseconds,
    };
  }

  bool get isComplete => ttiDuration != null && fmpDuration != null;
}

/// Extension to easily access page performance monitoring
extension PagePerformanceContext on BuildContext {
  void startPagePerformanceMonitoring(String pageId,
      {Map<String, dynamic>? pageArgs}) {
    PagePerformanceMonitor().startPageLoad(pageId, pageArgs: pageArgs);
  }

  void markPageTimeToInteractive(String pageId) {
    PagePerformanceMonitor().markTimeToInteractive(pageId);
  }
}
