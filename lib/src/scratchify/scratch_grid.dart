class ScratchGrid {
  final int rows;
  final int cols;
  late List<bool> _scratched;
  int _scratchedCount = 0;

  ScratchGrid({this.rows = 50, this.cols = 50}) {
    _scratched = List.filled(rows * cols, false);
  }

  void scratch(int row, int col) {
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      final index = row * cols + col;
      if (!_scratched[index]) {
        _scratched[index] = true;
        _scratchedCount++;
      }
    }
  }

  void reset() {
    _scratched.fillRange(0, _scratched.length, false);
    _scratchedCount = 0;
  }

  double progress() {
    return _scratchedCount / (rows * cols);
  }

  bool isScratched(int row, int col) {
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      return _scratched[row * cols + col];
    }
    return false;
  }
}
