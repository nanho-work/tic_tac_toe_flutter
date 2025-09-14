import 'ai_base.dart';

class AIEasyService {
  static int? getMove(List<String> board, int size) {
    // 자기 승리 먼저
    int? move = AIBase.findWinningMove(board, 'O', size);
    if (move != null) return move;

    // 상대 차단 (4목, 열린3, XX_XX 등)
    move = AIBase.findBlockMove(board, 'X', size);
    if (move != null) return move;

    // 중앙 근처 가중치
    int center = size ~/ 2;
    int? bestMove;
    int bestScore = -9999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] != '') continue;
      int x = i % size;
      int y = i ~/ size;
      int score = (size - ((x - center).abs() + (y - center).abs()));
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
    return bestMove ?? AIBase.randomMove(board);
  }
}