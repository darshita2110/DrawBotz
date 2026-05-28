import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── GRADIENT BUTTON ──────────────────────────
class GradientButton extends StatefulWidget {
  final String label;
  final String? emoji;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final double fontSize;

  const GradientButton({super.key, required this.label, this.emoji,
    required this.gradient, required this.onTap,
    this.width, this.height = 52, this.fontSize = 17});

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp:   (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: widget.width, height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: widget.gradient.colors.first.withOpacity(0.45), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (widget.emoji != null) ...[Text(widget.emoji!, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8)],
            Text(widget.label, style: AppTextStyles.display(widget.fontSize, Colors.white)),
          ]),
        ),
      ),
    );
  }
}

// ── GHOST BUTTON ─────────────────────────────
class GhostButton extends StatelessWidget {
  final String label;
  final String? emoji;
  final VoidCallback onTap;
  const GhostButton({super.key, required this.label, this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.22), width: 2)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (emoji != null) ...[Text(emoji!, style: const TextStyle(fontSize: 18)), const SizedBox(width: 6)],
          Text(label, style: AppTextStyles.semiBold(14, Colors.white.withOpacity(0.45))),
        ]),
      ),
    );
  }
}

// ── GLASS CARD ───────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? borderColor;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.radius = 20, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: AppColors.glassLight, borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor ?? AppColors.glassBorder, width: 1)),
      child: child,
    );
  }
}

// ── APP CHIP ─────────────────────────────────
class AppChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;
  const AppChip({super.key, required this.label, this.emoji, required this.color, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? null : Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (emoji != null) ...[Text(emoji!, style: const TextStyle(fontSize: 13)), const SizedBox(width: 5)],
          Text(label, style: AppTextStyles.bold(12, isSelected ? Colors.white : color)),
        ]),
      ),
    );
  }
}

// ── TIP CARD ─────────────────────────────────
class TipCard extends StatelessWidget {
  final String tip, emoji;
  final Color color;
  const TipCard({super.key, required this.tip, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.22), width: 1)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(child: Text(tip, style: AppTextStyles.regular(11.5, color))),
      ]),
    );
  }
}

// ── STATUS BARS ──────────────────────────────
class LightStatusBar extends StatelessWidget {
  const LightStatusBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('9:41', style: AppTextStyles.bold(13, AppColors.ink.withOpacity(0.5))),
        Row(children: [
          Icon(Icons.signal_cellular_alt, size: 14, color: AppColors.ink.withOpacity(0.4)),
          const SizedBox(width: 4),
          Icon(Icons.wifi, size: 14, color: AppColors.ink.withOpacity(0.4)),
          const SizedBox(width: 4),
          _Battery(color: AppColors.ink.withOpacity(0.4)),
        ]),
      ]),
    );
  }
}

class DarkStatusBar extends StatelessWidget {
  const DarkStatusBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('9:41', style: AppTextStyles.bold(13, Colors.white.withOpacity(0.6))),
        Row(children: [
          Icon(Icons.signal_cellular_alt, size: 14, color: Colors.white.withOpacity(0.5)),
          const SizedBox(width: 4),
          Icon(Icons.wifi, size: 14, color: Colors.white.withOpacity(0.5)),
          const SizedBox(width: 4),
          _Battery(color: Colors.white.withOpacity(0.5)),
        ]),
      ]),
    );
  }
}

class _Battery extends StatelessWidget {
  final Color color;
  const _Battery({required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 22, height: 11,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: color, width: 1.5)),
        child: Padding(padding: const EdgeInsets.all(1.5),
          child: FractionallySizedBox(widthFactor: 0.75, alignment: Alignment.centerLeft,
            child: Container(decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(1))))),
      ),
      Container(width: 3, height: 6, margin: const EdgeInsets.only(left: 1),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.horizontal(right: Radius.circular(2)))),
    ]);
  }
}

// ── ICON CIRCLE BUTTON ───────────────────────
class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final String? emoji;
  final VoidCallback onTap;
  final Color? bgColor, borderColor;
  final double size;
  final bool pulsing;

  const IconCircleButton({super.key, this.icon = Icons.arrow_back, this.emoji,
    required this.onTap, this.bgColor, this.borderColor, this.size = 40, this.pulsing = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.glassLight,
          borderRadius: BorderRadius.circular(size * 0.3),
          border: borderColor != null ? Border.all(color: borderColor!, width: 1) : null,
        ),
        child: Center(child: emoji != null
            ? Text(emoji!, style: TextStyle(fontSize: size * 0.44))
            : Icon(icon, color: Colors.white, size: size * 0.5)),
      ),
    );
  }
}

// ── PAGE DOTS ────────────────────────────────
class PageDots extends StatelessWidget {
  final int count, current;
  final Color activeColor;
  const PageDots({super.key, required this.count, required this.current, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final on = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: on ? 24 : 8, height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: on ? activeColor : AppColors.ink.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}