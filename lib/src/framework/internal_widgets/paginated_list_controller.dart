import 'package:flutter/foundation.dart';

class PaginatedListController extends ChangeNotifier {
  PaginatedListController();

  /// Asks any listening paginated view to re-fetch from the first page.
  void invalidate() {
    notifyListeners();
  }
}
