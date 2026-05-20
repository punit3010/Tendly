import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The Tendly plant icon — drawn in pure Flutter, no image assets needed.
/// Use [size] to scale it. Background is always [TendlyColors.primary].
class TendlyIcon extends StatelessWidget {
  final double size;
  final double borderRadius;

  const TendlyIcon({super.key, this.size = 80, this.borderRadius = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        color:        TendlyColors.primaryDark,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: CustomPaint(
        painter: _PlantPainter(),
      ),
    );
  }
}

class _PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final stemPaint = Paint()
      ..color   = TendlyColors.primaryLight
      ..strokeWidth = w * 0.07
      ..strokeCap   = StrokeCap.round
      ..style       = PaintingStyle.stroke;

    final leafWhite = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..style = PaintingStyle.fill;

    final leafMint = Paint()
      ..color = TendlyColors.primaryLight
      ..style = PaintingStyle.fill;

    final groundPaint = Paint()
      ..color = TendlyColors.primaryDeep.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Ground ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.84),
        width:  w * 0.55,
        height: h * 0.1,
      ),
      groundPaint,
    );

    // Stem
    canvas.drawLine(
      Offset(w * 0.5, h * 0.82),
      Offset(w * 0.5, h * 0.38),
      stemPaint,
    );

    // Left leaf (white)
    final leftLeaf = Path()
      ..moveTo(w * 0.5,  h * 0.58)
      ..cubicTo(w * 0.5,  h * 0.58,
                w * 0.18, h * 0.53,
                w * 0.15, h * 0.36)
      ..cubicTo(w * 0.15, h * 0.36,
                w * 0.38, h * 0.30,
                w * 0.5,  h * 0.50)
      ..close();
    canvas.drawPath(leftLeaf, leafWhite);

    // Right leaf (mint)
    final rightLeaf = Path()
      ..moveTo(w * 0.5,  h * 0.50)
      ..cubicTo(w * 0.5,  h * 0.50,
                w * 0.82, h * 0.42,
                w * 0.85, h * 0.25)
      ..cubicTo(w * 0.85, h * 0.25,
                w * 0.62, h * 0.22,
                w * 0.5,  h * 0.40)
      ..close();
    canvas.drawPath(rightLeaf, leafMint);

    // Small bud at top
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.36),
      w * 0.065,
      Paint()..color = Colors.white.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Full logo lockup: icon + wordmark + optional tagline
class TendlyLogo extends StatelessWidget {
  final double iconSize;
  final bool showTagline;

  const TendlyLogo({super.key, this.iconSize = 72, this.showTagline = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TendlyIcon(size: iconSize, borderRadius: iconSize * 0.25),
        const SizedBox(height: 14),
        Text(
          'Tendly',
          style: TextStyle(
            fontFamily:  'Poppins',
            fontSize:    iconSize * 0.36,
            fontWeight:  FontWeight.w600,
            color:       TendlyColors.primaryDeep,
            letterSpacing: -0.5,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'Grow together, every day',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize:   iconSize * 0.17,
              color:      TendlyColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
