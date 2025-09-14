// 이 파일은 UI 전용 코드입니다.
// 역할: 바둑판, 돌, 마지막 수 표시, 승리선 그리기.
import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter {
  final List<String> board;
  final int? lastMoveIndex;
  final List<Offset>? winningLine;

  static const int size = 10;

  BoardPainter(this.board, {this.lastMoveIndex, this.winningLine});

  @override
  void paint(Canvas canvas, Size sizeCanvas) {
    // 바둑판 배경
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sizeCanvas.width, sizeCanvas.height),
      Paint()..color = Colors.brown[200]!,
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    final double cellSize = sizeCanvas.width / (size - 1);

    // 격자 그리기
    for (int i = 0; i < size; i++) {
      final double offset = i * cellSize;
      canvas.drawLine(Offset(offset, 0), Offset(offset, sizeCanvas.height), paint);
      canvas.drawLine(Offset(0, offset), Offset(sizeCanvas.width, offset), paint);
    }

    final stoneRadius = cellSize * 0.4;
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final index = y * size + x;
        final stone = board[index];
        if (stone == 'X' || stone == 'O') {
          final center = Offset(x * cellSize, y * cellSize);
          if (stone == 'X') {
            final gradient = RadialGradient(
              colors: [Colors.grey[800]!, Colors.black],
              center: Alignment(-0.2, -0.2),
              radius: 0.9,
            );
            final rect = Rect.fromCircle(center: center, radius: stoneRadius);
            final paintGradient = Paint()
              ..shader = gradient.createShader(rect)
              ..isAntiAlias = true;
            canvas.drawCircle(center, stoneRadius, paintGradient);
          } else {
            final gradient = RadialGradient(
              colors: [Colors.white, Colors.grey[300]!],
              center: Alignment(-0.2, -0.2),
              radius: 0.9,
            );
            final rect = Rect.fromCircle(center: center, radius: stoneRadius);
            final paintGradient = Paint()
              ..shader = gradient.createShader(rect)
              ..isAntiAlias = true;
            canvas.drawCircle(center, stoneRadius, paintGradient);
            final borderPaint = Paint()
              ..color = Colors.black
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5;
            canvas.drawCircle(center, stoneRadius, borderPaint);
          }

          // 마지막 수 표시
          if (lastMoveIndex == index) {
            final redDotPaint = Paint()
              ..color = Colors.red
              ..style = PaintingStyle.fill;
            canvas.drawCircle(center, stoneRadius * 0.25, redDotPaint);
          }
        }
      }
    }

    // 승리선
    if (winningLine != null && winningLine!.length == 2) {
      final Offset start = Offset(
        winningLine![0].dx * cellSize,
        winningLine![0].dy * cellSize,
      );
      final Offset end = Offset(
        winningLine![1].dx * cellSize,
        winningLine![1].dy * cellSize,
      );
      final winPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = cellSize * 0.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(start, end, winPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.board != board ||
        oldDelegate.lastMoveIndex != lastMoveIndex ||
        oldDelegate.winningLine != winningLine;
  }
}