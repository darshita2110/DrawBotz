import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  late AnimationController _scanCtrl, _aiCtrl, _flashCtrl, _shutterCtrl;
  late Animation<double> _scanAnim, _aiAnim, _flashAnim;
  int _mode = 0;
  final _modes = [('🐉', 'Character'), ('🏠', 'Object'), ('🌳', 'Scene')];

  @override
  void initState() {
    super.initState();
    _scanCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();
    _scanAnim    = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut));
    _aiCtrl      = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _aiAnim      = Tween<double>(begin: 0.25, end: 0.88).animate(CurvedAnimation(parent: _aiCtrl, curve: Curves.easeInOut));
    _flashCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _flashAnim   = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(parent: _flashCtrl, curve: Curves.easeInOut));
    _shutterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
  }

  @override
  void dispose() { _scanCtrl.dispose(); _aiCtrl.dispose(); _flashCtrl.dispose(); _shutterCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: SafeArea(child: Column(children: [
        const DarkStatusBar(),

        // Top bar
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
          child: Row(children: [
            IconCircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop()),
            const Spacer(),
            Text('Scan Drawing', style: AppTextStyles.display(16, Colors.white)),
            const Spacer(),
            AnimatedBuilder(
              animation: _flashAnim,
              builder: (_, child) => Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppColors.yolk.withOpacity(0.35), blurRadius: 8 + _flashAnim.value)]),
                child: child,
              ),
              child: IconCircleButton(emoji: '⚡', onTap: () {},
                  bgColor: AppColors.yolk.withOpacity(0.12), borderColor: AppColors.yolk.withOpacity(0.3)),
            ),
          ]),
        ),

        // Camera viewport
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF111825), Color(0xFF0B1420)]),
                border: Border.all(color: Colors.white.withOpacity(0.07), width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(children: [
                // Scan line
                AnimatedBuilder(animation: _scanAnim, builder: (_, __) {
                  final opacity = _scanAnim.value < 0.9 ? 1.0 : (1 - (_scanAnim.value - 0.9) / 0.1);
                  return Positioned(top: _scanAnim.value * 230, left: 0, right: 0,
                    child: Opacity(opacity: opacity, child: Container(height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.transparent, AppColors.mint, Colors.transparent]),
                        boxShadow: [BoxShadow(color: AppColors.mint, blurRadius: 12)],
                      ))));
                }),
                // Corners
                ..._corners(),
                // Drawing preview
                Center(child: _DrawingPreview()),
                // Detected label
                Positioned(top: 12, right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(9)),
                    child: Text('CHARACTER DETECTED ✓', style: AppTextStyles.bold(9, Colors.white.withOpacity(0.65))),
                  )),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TipCard(emoji: '💡', tip: 'Center drawing on white paper. Good lighting = better magic!', color: AppColors.mint)),
        const SizedBox(height: 10),

        // Mode selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: List.generate(_modes.length, (i) => Expanded(
            child: Padding(padding: EdgeInsets.only(right: i < _modes.length - 1 ? 8 : 0),
              child: AppChip(label: _modes[i].$2, emoji: _modes[i].$1, color: AppColors.lavender,
                isSelected: _mode == i, onTap: () => setState(() => _mode = i)))))),
        ),

        const Spacer(),

        // Shutter row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _SideBtn(emoji: '🖼️', onTap: () {}),
            const SizedBox(width: 28),
            _Shutter(ctrl: _shutterCtrl, onTap: () => Navigator.of(context).pushNamed('/ar')),
            const SizedBox(width: 28),
            _SideBtn(emoji: '⚙️', onTap: () {}),
          ]),
        ),
        const SizedBox(height: 12),

        // AI bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
                child: AnimatedBuilder(animation: _aiAnim,
                  builder: (_, __) => LinearProgressIndicator(value: _aiAnim.value, minHeight: 5,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: const AlwaysStoppedAnimation(AppColors.mint))))),
              const SizedBox(width: 12),
              Text('AI READY', style: AppTextStyles.caption(10, Colors.white.withOpacity(0.35))),
            ]),
          ),
        ),
      ])),
    );
  }

  List<Widget> _corners() {
    const s = 22.0; const t = 12.0; const r = 2.5;
    return [
      Positioned(top: t, left: t,    child: CustomPaint(painter: _Corner(AppColors.mint, s, r, _C.tl))),
      Positioned(top: t, right: t,   child: CustomPaint(painter: _Corner(AppColors.mint, s, r, _C.tr))),
      Positioned(bottom: t, left: t,  child: CustomPaint(painter: _Corner(AppColors.mint, s, r, _C.bl))),
      Positioned(bottom: t, right: t, child: CustomPaint(painter: _Corner(AppColors.mint, s, r, _C.br))),
    ];
  }
}

class _DrawingPreview extends StatefulWidget {
  @override State<_DrawingPreview> createState() => _DrawingPreviewState();
}
class _DrawingPreviewState extends State<_DrawingPreview> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true); _pulse = Tween<double>(begin: 0.85, end: 1.05).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _pulse,
    builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
    child: CustomPaint(size: const Size(110, 110), painter: _CrayonPainter()));
}

class _CrayonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final y = Paint()..color = AppColors.yolk.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final c = Paint()..color = AppColors.coral.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final lF = Paint()..color = AppColors.lavender.withOpacity(0.55)..style = PaintingStyle.fill;
    final lS = Paint()..color = AppColors.lavender.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 1.8;
    final d  = Paint()..color = AppColors.mint.withOpacity(0.45)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    canvas.drawCircle(const Offset(55, 38), 18, y);
    canvas.drawCircle(const Offset(47, 34), 3.5, Paint()..color = AppColors.yolk.withOpacity(0.75));
    canvas.drawCircle(const Offset(63, 34), 3.5, Paint()..color = AppColors.yolk.withOpacity(0.75));
    canvas.drawPath(Path()..moveTo(47, 45)..quadraticBezierTo(55, 54, 63, 45), c);
    final lh = Path()..moveTo(42, 28)..lineTo(36, 14)..lineTo(50, 25)..close();
    canvas.drawPath(lh, lF); canvas.drawPath(lh, lS);
    final rh = Path()..moveTo(68, 28)..lineTo(74, 14)..lineTo(60, 25)..close();
    canvas.drawPath(rh, lF); canvas.drawPath(rh, lS);
    canvas.drawOval(const Rect.fromLTWH(39, 56, 32, 28), y);
    canvas.drawPath(Path()..moveTo(39, 68)..quadraticBezierTo(28, 61, 30, 73), y);
    canvas.drawPath(Path()..moveTo(71, 68)..quadraticBezierTo(82, 61, 80, 73), y);
    _dashedCircle(canvas, const Offset(55, 38), 24, d);
  }
  void _dashedCircle(Canvas canvas, Offset c, double r, Paint p) {
    const dash = 4.0, gap = 3.0;
    final circ = 2 * math.pi * r; final total = dash + gap;
    final n = (circ / total).floor();
    for (var i = 0; i < n; i++) {
      final s = i * total / circ * 2 * math.pi;
      final e = (i * total + dash) / circ * 2 * math.pi;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), s, e - s, false, p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

enum _C { tl, tr, bl, br }
class _Corner extends CustomPainter {
  final Color color; final double size, r; final _C c;
  _Corner(this.color, this.size, this.r, this.c);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = r..strokeCap = StrokeCap.round;
    switch (c) {
      case _C.tl: canvas.drawLine(Offset(0, size), Offset.zero, p); canvas.drawLine(Offset.zero, Offset(size, 0), p); break;
      case _C.tr: canvas.drawLine(Offset(size, size), Offset(size, 0), p); canvas.drawLine(Offset(size, 0), Offset.zero, p); break;
      case _C.bl: canvas.drawLine(Offset.zero, Offset(0, size), p); canvas.drawLine(Offset(0, size), Offset(size, size), p); break;
      case _C.br: canvas.drawLine(Offset(size, 0), Offset(size, size), p); canvas.drawLine(Offset(size, size), Offset(0, size), p); break;
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _Shutter extends StatelessWidget {
  final AnimationController ctrl; final VoidCallback onTap;
  const _Shutter({required this.ctrl, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: AnimatedBuilder(animation: ctrl, builder: (_, __) => Container(width: 70, height: 70,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 5),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.12), blurRadius: 8 + ctrl.value * 6, spreadRadius: ctrl.value * 6),
          const BoxShadow(color: Color(0x80000000), blurRadius: 24, offset: Offset(0, 10))]))));
}

class _SideBtn extends StatelessWidget {
  final String emoji; final VoidCallback onTap;
  const _SideBtn({required this.emoji, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(width: 46, height: 46,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(15)),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))));
}