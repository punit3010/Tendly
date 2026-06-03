import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── TOPO BACKGROUND SVG ─────────────────────────────────────────────────────
class TopoBackground extends StatelessWidget {
  const TopoBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _TopoPainter()),
    );
  }
}

class _TopoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.065)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final paths = [
      'M0,${size.height * 0.85} Q${size.width * 0.14},${size.height * 0.45} ${size.width * 0.33},${size.height * 0.75} Q${size.width * 0.51},${size.height * 1.05} ${size.width * 0.7},${size.height * 0.55} Q${size.width * 0.88},${size.height * 0.05} ${size.width * 1.07},${size.height * 0.35}',
      'M0,${size.height * 0.95} Q${size.width * 0.19},${size.height * 0.55} ${size.width * 0.37},${size.height * 0.85} Q${size.width * 0.56},${size.height * 1.15} ${size.width * 0.74},${size.height * 0.65} Q${size.width * 0.93},${size.height * 0.15} ${size.width * 1.12},${size.height * 0.45}',
    ];

    for (final pathStr in paths) {
      canvas.drawPath(_parsePath(pathStr, size), paint);
    }
  }

  Path _parsePath(String _, Size size) {
    // Simplified: draw two gentle curves
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(size.width * 0.25, size.height * 0.4,
        size.width * 0.5,  size.height * 1.0,
        size.width * 0.75, size.height * 0.5);
    path.cubicTo(size.width * 0.88, size.height * 0.2,
        size.width * 1.0,  size.height * 0.4,
        size.width * 1.1,  size.height * 0.35);
    return path;
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── DARK SCREEN HEADER (Stories, Kitchen, Activities) ────────────────────────
class DarkScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color bgColorEnd;
  final VoidCallback onBack;
  final Widget? trailing;

  const DarkScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.bgColorEnd,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, bgColorEnd],
        ),
      ),
      child: Stack(
        children: [
          const TopoBackground(),
          Padding(
            padding: EdgeInsets.fromLTRB(
                THeader.sidePad, top + 12, THeader.sidePad, THeader.roomBotPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BackButton(onTap: onBack),
                const SizedBox(height: 12),
                Text(title, style: TText.display(30, color: Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle, style: TText.body(13, color: Colors.white.withOpacity(0.55))),
                if (trailing != null) ...[const SizedBox(height: 12), trailing!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── LIGHT SCREEN HEADER (Health, Circles) ───────────────────────────────────
class LightScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack;
  final VoidCallback? onBack;

  const LightScreenHeader({
    super.key, required this.title, required this.subtitle,
    this.showBack = true, this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: TColors.surface,
      padding: EdgeInsets.fromLTRB(
          THeader.sidePad, top + 12, THeader.sidePad, THeader.roomBotPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack && onBack != null) ...[
            _BackButton(onTap: onBack!, dark: false),
            const SizedBox(height: 12),
          ],
          Text(title, style: TText.display(28, color: TColors.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: TText.body(13, color: TColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── BACK BUTTON ─────────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool dark;
  const _BackButton({required this.onTap, this.dark = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: dark ? Colors.white.withOpacity(0.1) : TColors.tealSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.arrow_back_ios_new_rounded, size: 12,
              color: dark ? Colors.white : TColors.forest),
          const SizedBox(width: 4),
          Text('Back', style: TText.body(12,
              weight: FontWeight.w700,
              color: dark ? Colors.white : TColors.forest)),
        ]),
      ),
    );
  }
}

// ─── PRO BADGE ───────────────────────────────────────────────────────────────
class ProBadge extends StatelessWidget {
  const ProBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: TColors.terracotta,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text('PRO', style: TText.eyebrow(color: Colors.white)),
  );
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: THeader.sidePad),
    child: Row(children: [
      Text(title, style: TText.display(19, color: TColors.textPrimary)),
      const Spacer(),
      if (action != null)
        GestureDetector(
          onTap: onAction,
          child: Text(action!, style: TText.body(13,
              weight: FontWeight.w600, color: TColors.forestLight)),
        ),
    ]),
  );
}

// ─── TENDLY SNACKBAR ─────────────────────────────────────────────────────────
void showTToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: TText.body(13, weight: FontWeight.w600, color: Colors.white)),
    backgroundColor: TColors.textPrimary,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    margin: const EdgeInsets.fromLTRB(24, 0, 24, 100),
    duration: const Duration(milliseconds: 2400),
    elevation: 0,
  ));
}

// ─── TOGGLE SWITCH ───────────────────────────────────────────────────────────
class TToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const TToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44, height: 26,
      decoration: BoxDecoration(
        color: value ? TColors.forest : TColors.border,
        borderRadius: BorderRadius.circular(13),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20, height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x26000000), blurRadius: 3, offset: Offset(0,1))],
          ),
        ),
      ),
    ),
  );
}
