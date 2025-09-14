class AIBase {
  /// 랜덤 수 선택
  static int? randomMove(List<String> board) {
    List<int> emptyIndices = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') emptyIndices.add(i);
    }
    if (emptyIndices.isEmpty) return null;
    emptyIndices.shuffle();
    return emptyIndices.first;
  }

  /// 4목에서 즉시 승리 수 찾기
  static int? findWinningMove(List<String> board, String player, int size) {
    const directions = [
      [1, 0], [0, 1], [1, 1], [-1, 1],
    ];
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        for (var dir in directions) {
          int count = 0, emptyCount = 0, emptyIndex = -1;
          bool blocked = false;
          for (int i = 0; i < 5; i++) {
            int nx = x + dir[0] * i;
            int ny = y + dir[1] * i;
            if (nx < 0 || nx >= size || ny < 0 || ny >= size) { blocked = true; break; }
            int idx = ny * size + nx;
            if (board[idx] == player) {
              count++;
            } else if (board[idx] == '') {
              emptyCount++; emptyIndex = idx;
            } else {
              blocked = true; break;
            }
          }
          if (!blocked && count == 4 && emptyCount == 1) return emptyIndex;
        }
      }
    }
    return null;
  }

  /// 상대 차단 (4목, 열린3, XX_XX 패턴)
  static int? findBlockMove(List<String> board, String player, int size) {
    const directions = [
      [1, 0], [0, 1], [1, 1], [-1, 1],
    ];
    int? bestMove;
    int bestPriority = 0;

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        for (var dir in directions) {
          int count = 0, emptyCount = 0;
          List<int> empties = [];
          bool blocked = false;
          for (int i = 0; i < 5; i++) {
            int nx = x + dir[0] * i;
            int ny = y + dir[1] * i;
            if (nx < 0 || nx >= size || ny < 0 || ny >= size) { blocked = true; break; }
            int idx = ny * size + nx;
            if (board[idx] == player) {
              count++;
            } else if (board[idx] == '') {
              emptyCount++; empties.add(idx);
            } else {
              blocked = true; break;
            }
          }
          if (!blocked) {
            if (count == 4 && emptyCount == 1 && bestPriority < 3) {
              bestPriority = 3;
              bestMove = empties.first;
            }
            if (count == 3 && emptyCount == 2 && bestPriority < 2) {
              bestPriority = 2;
              bestMove = empties.first;
            }
            if (count == 2 && emptyCount == 1 && bestPriority < 1) {
              bestPriority = 1;
              bestMove = empties.first;
            }
          }
        }
      }
    }
    return bestMove;
  }
}