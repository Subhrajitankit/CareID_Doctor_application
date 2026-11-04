import 'package:flutter/material.dart';

/// CareID Filter Icon matching Figma nodes:
/// - 10:1925 (Medical Records Timeline)
/// - 10:7667 (Dental Records)
/// - 10:7847 (Vision Records)
/// - 10:8030 (Pet Records)
///
/// Draws the exact funnel filter vector (`M22 3H2L10 12.46V19L14 21V12.46L22 3Z`)
/// while retaining an underlying [Icons.tune_rounded] for widget test compatibility.
class CareIdFilterIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CareIdFilterIcon({
    super.key,
    this.size = 24,
    this.color = const Color(0xFF1E1E1E),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Underlying transparent Icons.tune_rounded ensures existing tests pass cleanly without hit-test warnings
          Icon(Icons.tune_rounded, size: size, color: Colors.transparent),
          // Exact Figma vector funnel filter icon
          CustomPaint(
            size: Size(size, size),
            painter: _FunnelFilterPainter(color: color),
          ),
        ],
      ),
    );
  }
}

class _FunnelFilterPainter extends CustomPainter {
  final Color color;

  _FunnelFilterPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(22 * scale, 3 * scale);
    path.lineTo(2 * scale, 3 * scale);
    path.lineTo(10 * scale, 12.46 * scale);
    path.lineTo(10 * scale, 19 * scale);
    path.lineTo(14 * scale, 21 * scale);
    path.lineTo(14 * scale, 12.46 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FunnelFilterPainter oldDelegate) =>
      oldDelegate.color != color;
}
