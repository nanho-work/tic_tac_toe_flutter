import 'ai_base.dart';

class AINormalService {
  static int? getMove(List<String> board, int size) {
    int? bestMove;
    int bestScore = -999999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] != '') continue;
      board[i] = 'O';

      // 즉시 승리면 바로 반환
      if (AIBase.findWinningMove(board, 'O', size) == null && _checkWin(board, size, 'O')) {
        board[i] = '';
        return i;
      }

      // 점수 계산
      int score = _evaluateBoard(board, size);

      // 상대 응수 고려 (1-ply minimax)
      int? oppMove = AIBase.findWinningMove(board, 'X', size);
      if (oppMove != null) score -= 2000; // 상대가 곧바로 이기면 큰 패널티

      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
      board[i] = '';
    }

    return bestMove ?? AIBase.randomMove(board);
  }

  static int _evaluateBoard(List<String> board, int size) {
    int score = 0;
    int center = size ~/ 2;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') continue;
      int x = i % size;
      int y = i ~/ size;
      int dist = (x - center).abs() + (y - center).abs();
      if (board[i] == 'O') {
        score += (size - dist);
      } else {
        score -= (size - dist);
      }
    }
    return score;
  }

  static bool _checkWin(List<String> board, int size, String player) {
    const directions = [
      [1, 0], [0, 1], [1, 1], [-1, 1],
    ];
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (board[y * size + x] != player) continue;
        for (var dir in directions) {
          int count = 1;
          int nx = x, ny = y;
          while (true) {
            nx += dir[0]; ny += dir[1];
            if (nx < 0 || nx >= size || ny < 0 || ny >= size) break;
            if (board[ny * size + nx] == player) {
              count++;
            } else break;
          }
          if (count >= 5) return true;
        }
      }
    }
    return false;
  }
}