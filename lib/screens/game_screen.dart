import 'package:flutter/material.dart';
import '../widgets/board_painter.dart';
import '../services/ai_service.dart';

class GameScreen extends StatefulWidget {
  final String difficulty;
  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int size = 10;
  List<String> board = List.filled(size * size, '');
  String currentPlayer = 'X';
  String? winner;
  int? lastMoveIndex;
  List<Offset>? winningLine;
  List<int> moveHistory = [];

  void _handleTap(int index) {
    if (board[index] != '' || winner != null) return;

    setState(() {
      board[index] = currentPlayer;
      moveHistory.add(index);
      lastMoveIndex = index;

      if (_checkWinner(currentPlayer)) {
        winner = currentPlayer;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });

    if (currentPlayer == 'O' && winner == null) {
      Future.delayed(const Duration(milliseconds: 300), _aiMove);
    }
  }

  void _aiMove() {
    if (winner != null) return;

    int? moveIndex = AIService.getMove(board, widget.difficulty, size);

    if (moveIndex == null) return;

    setState(() {
      board[moveIndex] = currentPlayer;
      moveHistory.add(moveIndex);
      lastMoveIndex = moveIndex;

      if (_checkWinner(currentPlayer)) {
        winner = currentPlayer;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  bool _checkWinner(String player) {
    const directions = [
      [1, 0], [0, 1], [1, 1], [-1, 1],
    ];
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (board[y * size + x] != player) continue;
        for (var dir in directions) {
          int count = 1;
          int nx = x, ny = y;
          int startX = x, startY = y;
          int endX = x, endY = y;
          while (true) {
            nx += dir[0]; ny += dir[1];
            if (nx < 0 || nx >= size || ny < 0 || ny >= size) break;
            if (board[ny * size + nx] == player) {
              count++; endX = nx; endY = ny;
            } else break;
          }
          if (count >= 5) {
            final start = Offset(startX.toDouble(), startY.toDouble());
            final end = Offset(endX.toDouble(), endY.toDouble());
            winningLine = [start, end];
            return true;
          }
        }
      }
    }
    winningLine = null;
    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(size * size, '');
      currentPlayer = 'X';
      winner = null;
      lastMoveIndex = null;
      winningLine = null;
      moveHistory.clear();
    });
  }

  void _undoMove() {
    if (moveHistory.isNotEmpty && winner == null) {
      setState(() {
        int lastIndex = moveHistory.removeLast();
        board[lastIndex] = '';
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (moveHistory.isNotEmpty) {
          lastMoveIndex = moveHistory.last;
        } else {
          lastMoveIndex = null;
        }
        winningLine = null;
      });
    }
  }

  Widget playerCircle(String player, {double size = 18}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: player == 'X' ? Colors.black : Colors.white,
        border: player == 'O'
            ? Border.all(color: Colors.black, width: 1.5)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boardSize = (screenSize.height * 0.8).clamp(300.0, 600.0);
    final cellSize = boardSize / (size - 1);

    return Scaffold(
      appBar: AppBar(title: Text('오목 - ${widget.difficulty} 모드')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: boardSize,
                  height: boardSize,
                  child: GestureDetector(
                    onTapDown: (details) {
                      final localPosition = details.localPosition;
                      int x = (localPosition.dx / cellSize).round();
                      int y = (localPosition.dy / cellSize).round();
                      if (x < 0) x = 0;
                      if (x >= size) x = size - 1;
                      if (y < 0) y = 0;
                      if (y >= size) y = size - 1;
                      int index = y * size + x;
                      _handleTap(index);
                    },
                    child: CustomPaint(
                      size: Size(boardSize, boardSize),
                      painter: BoardPainter(
                        board,
                        lastMoveIndex: lastMoveIndex,
                        winningLine: winningLine,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.white.withOpacity(0.7),
                    child: winner != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              playerCircle(winner!, size: 24),
                              const SizedBox(width: 10),
                              const Text(
                                '승리',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              playerCircle(currentPlayer, size: 24),
                              const SizedBox(width: 10),
                              const Text(
                                '순서',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _undoMove,
                  child: const Text('🔙'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('Reset Game'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}