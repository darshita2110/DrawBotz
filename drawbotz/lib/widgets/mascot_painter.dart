import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class MascotPainter extends CustomPainter {
  final double animValue;
  final Color glowColor;
  MascotPainter({required this.animValue, this.glowColor = Colors.transparent});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 130.0;
    canvas.save();
    canvas.scale(scale, scale);
    _draw(canvas);
    canvas.restore();
  }

  void _draw(Canvas canvas) {
    final bodyPaint    = Paint()..color = AppColors.yolk;
    final outlinePaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final whitePaint  = Paint()..color = Colors.white;
    final pupilPaint  = Paint()..color = AppColors.ink;
    final blushPaint  = Paint()..color = AppColors.coral.withOpacity(0.38);
    final hornPaint   = Paint()..color = AppColors.lavender;
    final coralPaint  = Paint()..color = AppColors.coral;
    final tummyPaint  = Paint()..color = Colors.white.withOpacity(0.22);

    // Tail
    canvas.drawPath(
      Path()..moveTo(92, 106)..cubicTo(110, 118, 112, 122, 108, 128),
      Paint()..color = AppColors.yolk..style = PaintingStyle.stroke..strokeWidth = 7..strokeCap = StrokeCap.round,
    );
    final tailSpike = Path()..moveTo(104, 126)..lineTo(112, 122)..lineTo(110, 130)..close();
    canvas.drawPath(tailSpike, coralPaint);
    canvas.drawPath(tailSpike, outlinePaint..strokeWidth = 1.5);

    // Body
    canvas.drawOval(const Rect.fromLTWH(32, 55, 66, 58), bodyPaint);
    canvas.drawOval(const Rect.fromLTWH(32, 55, 66, 58), outlinePaint..strokeWidth = 2.5);

    // Arms
    final armPaint = Paint()..color = AppColors.yolk..style = PaintingStyle.stroke..strokeWidth = 9..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(33, 82)..cubicTo(18, 72, 15, 76, 14, 88), armPaint);
    canvas.drawPath(Path()..moveTo(97, 82)..cubicTo(112, 72, 115, 76, 116, 88), armPaint);

    // Hands
    canvas.drawCircle(const Offset(14, 90), 7.5, bodyPaint);
    canvas.drawCircle(const Offset(14, 90), 7.5, outlinePaint..strokeWidth = 1.5);
    canvas.drawCircle(const Offset(116, 90), 7.5, bodyPaint);
    canvas.drawCircle(const Offset(116, 90), 7.5, outlinePaint..strokeWidth = 1.5);

    // Pencil
    final pencilPaint = Paint()..color = AppColors.coral;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(6, 91, 3.5, 16), const Radius.circular(1.5)), pencilPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(6, 91, 3.5, 16), const Radius.circular(1.5)), outlinePaint..strokeWidth = 1.0);
    final pencilTip = Path()..moveTo(6.5, 107)..lineTo(10, 107)..lineTo(8.2, 113)..close();
    canvas.drawPath(pencilTip, bodyPaint);
    canvas.drawPath(pencilTip, outlinePaint..strokeWidth = 0.8);

    // Horns
    final leftHorn = Path()..moveTo(43, 26)..lineTo(36, 6)..lineTo(52, 21)..close();
    final rightHorn = Path()..moveTo(87, 26)..lineTo(94, 6)..lineTo(78, 21)..close();
    canvas.drawPath(leftHorn, hornPaint);
    canvas.drawPath(leftHorn, outlinePaint..strokeWidth = 2.2);
    canvas.drawPath(rightHorn, hornPaint);
    canvas.drawPath(rightHorn, outlinePaint..strokeWidth = 2.2);

    // Head
    canvas.drawCircle(const Offset(65, 50), 30, bodyPaint);
    canvas.drawCircle(const Offset(65, 50), 30, outlinePaint..strokeWidth = 2.5);

    // Tummy
    canvas.drawOval(const Rect.fromLTWH(47, 71, 36, 28), tummyPaint);

    // Eyes
    canvas.drawOval(const Rect.fromLTWH(46.5, 37.5, 15, 17), whitePaint);
    canvas.drawOval(const Rect.fromLTWH(46.5, 37.5, 15, 17), outlinePaint..strokeWidth = 1.5);
    canvas.drawOval(const Rect.fromLTWH(68.5, 37.5, 15, 17), whitePaint);
    canvas.drawOval(const Rect.fromLTWH(68.5, 37.5, 15, 17), outlinePaint..strokeWidth = 1.5);
    canvas.drawCircle(const Offset(55, 47), 4.5, pupilPaint);
    canvas.drawCircle(const Offset(77, 47), 4.5, pupilPaint);
    canvas.drawCircle(const Offset(57, 45), 1.8, whitePaint);
    canvas.drawCircle(const Offset(79, 45), 1.8, whitePaint);

    // Smile
    canvas.drawPath(Path()..moveTo(54, 62)..cubicTo(59, 68, 71, 68, 76, 62), outlinePaint..strokeWidth = 2.5);

    // Blush
    canvas.drawOval(const Rect.fromLTWH(34, 53.5, 16, 11), blushPaint);
    canvas.drawOval(const Rect.fromLTWH(80, 53.5, 16, 11), blushPaint);
  }

  @override
  bool shouldRepaint(MascotPainter old) => old.animValue != animValue;
}

class AnimatedMascot extends StatefulWidget {
  final double size;
  final bool glowing;
  const AnimatedMascot({super.key, this.size = 150, this.glowing = false});

  @override
  State<AnimatedMascot> createState() => _AnimatedMascotState();
}

class _AnimatedMascotState extends State<AnimatedMascot> with TickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late AnimationController _sparkCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);
    _sparkCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _bounceAnim = Tween<double>(begin: 0, end: -12).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _bounceCtrl.dispose(); _sparkCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + 40,
      height: widget.size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ..._buildSparkles(),
          AnimatedBuilder(
            animation: _bounceAnim,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _bounceAnim.value),
              child: widget.glowing ? _withGlow() : _mascot(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mascot() => CustomPaint(size: Size(widget.size, widget.size), painter: MascotPainter(animValue: _bounceCtrl.value));

  Widget _withGlow() => Container(
    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      BoxShadow(color: AppColors.mint.withOpacity(0.5), blurRadius: 20, spreadRadius: 4),
      BoxShadow(color: AppColors.yolk.withOpacity(0.25), blurRadius: 40, spreadRadius: 10),
    ]),
    child: _mascot(),
  );

  List<Widget> _buildSparkles() {
    final data = [
      _S(top: 10,   right: 30, color: AppColors.coral,    size: 10, delay: 0.0),
      _S(top: 35,   left: 20,  color: AppColors.lavender,  size: 8,  delay: 0.4),
      _S(bottom: 12, right: 22, color: AppColors.mint,    size: 7,  delay: 0.9),
      _S(top: 18,   left: 50,  color: AppColors.yolk,     size: 6,  delay: 1.4),
    ];
    return data.map((s) => AnimatedBuilder(
      animation: _sparkCtrl,
      builder: (_, __) {
        final phase   = (_sparkCtrl.value + s.delay) % 1.0;
        final scale   = 0.6 + 0.8 * math.sin(phase * math.pi);
        final opacity = math.sin(phase * math.pi).clamp(0.0, 1.0);
        return Positioned(
          top: s.top, bottom: s.bottom, left: s.left, right: s.right,
          child: Transform.scale(scale: scale, child: Opacity(opacity: opacity,
            child: Container(width: s.size, height: s.size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: s.color,
                boxShadow: [BoxShadow(color: s.color.withOpacity(0.5), blurRadius: 6)]),
            ),
          )),
        );
      },
    )).toList();
  }
}

class _S {
  final double? top, bottom, left, right;
  final Color color;
  final double size, delay;
  const _S({this.top, this.bottom, this.left, this.right, required this.color, required this.size, required this.delay});
}