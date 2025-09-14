import 'ai_base.dart';

class AIHardService {
  static int? getMove(List<String> board, int size) {
    int? bestMove;
    int bestScore = -999999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] != '') continue;
      board[i] = 'O';
      int score = _minimax(board, size, 2, false, -999999, 999999);
      board[i] = '';
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
    return bestMove ?? AIBase.randomMove(board);
  }

  static int _minimax(List<String> board, int size, int depth, bool isMax, int alpha, int beta) {
    if (depth == 0) return _evaluateBoard(board, size);

    if (isMax) {
      int best = -999999;
      for (int i = 0; i < board.length; i++) {
        if (board[i] != '') continue;
        board[i] = 'O';
        best = best > _minimax(board, size, depth - 1, false, alpha, beta)
            ? best
            : _minimax(board, size, depth - 1, false, alpha, beta);
        board[i] = '';
        alpha = alpha > best ? alpha : best;
        if (beta <= alpha) break;
      }
      return best;
    } else {
      int best = 999999;
      for (int i = 0; i < board.length; i++) {
        if (board[i] != '') continue;
        board[i] = 'X';
        best = best < _minimax(board, size, depth - 1, true, alpha, beta)
            ? best
            : _minimax(board, size, depth - 1, true, alpha, beta);
        board[i] = '';
        beta = beta < best ? beta : best;
        if (beta <= alpha) break;
      }
      return best;
    }
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
}