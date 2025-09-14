import 'ai_easy_service.dart';
import 'ai_normal_service.dart';
import 'ai_hard_service.dart';

class AIService {
  /// 난이도에 따라 적절한 AI 로직 실행
  static int? getMove(List<String> board, String difficulty, int size) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AIEasyService.getMove(board, size);
      case 'normal':
        return AINormalService.getMove(board, size);
      case 'hard':
        return AIHardService.getMove(board, size);
      default:
        return null;
    }
  }
}