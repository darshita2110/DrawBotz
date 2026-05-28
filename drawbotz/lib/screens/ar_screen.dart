import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/mascot_painter.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});
  @override State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl, _ringCtrl, _particleCtrl, _shadowCtrl, _blinkCtrl, _saveCtrl;
  late Animation<double> _floatAnim, _shadowAnim, _blinkAnim, _saveScale;
  int _selAnim = 2;
  bool _saved = false;

  final _anims = [('💃','DANCE'), ('🏃','RUN'), ('👋','WAVE'), ('😴','SLEEP')];

  @override
  void initState() {
    super.initState();
    _floatCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _floatAnim    = Tween<double>(begin: 0, end: -10).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _ringCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat();
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();
    _shadowCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _shadowAnim   = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _shadowCtrl, curve: Curves.easeInOut));
    _blinkCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _blinkAnim    = Tween<double>(begin: 0.15, end: 1.0).animate(CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut));
    _saveCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _saveScale    = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _saveCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { for (final c in [_floatCtrl,_ringCtrl,_particleCtrl,_shadowCtrl,_blinkCtrl,_saveCtrl]) c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060C14),
      body: SafeArea(child: Column(children: [
        const DarkStatusBar(),

        // HUD
        Padding(padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
          child: Row(children: [
            _LiveBadge(anim: _blinkAnim),
            const Spacer(),
            Text('Your Doodle!', style: AppTextStyles.display(15, Colors.white)),
            const Spacer(),
            GestureDetector(onTap: () => Navigator.of(context).pop(),
              child: Container(width: 32, height: 32,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text('✕', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w700))))),
          ])),

        // AR viewport
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(borderRadius: BorderRadius.circular(24),
            child: Container(height: 220,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF111D2E), Color(0xFF080F1A)]),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(children: [
                // Grid
                Positioned(bottom: 0, left: 0, right: 0,
                  child: CustomPaint(size: const Size(double.infinity, 110), painter: _GridPainter())),
                // Rings
                ..._rings(),
                // Particles
                ..._particles(),
                // Shadow
                Positioned(bottom: 18, left: 0, right: 0,
                  child: Center(child: AnimatedBuilder(animation: _shadowAnim,
                    builder: (_, __) => Transform.scale(scaleX: _shadowAnim.value,
                      child: Container(width: 58, height: 14,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                          color: AppColors.mint.withOpacity(0.22),
                          boxShadow: [BoxShadow(color: AppColors.mint.withOpacity(0.15), blurRadius: 12)])))))),
                // Character
                Positioned(bottom: 26, left: 0, right: 0,
                  child: Center(child: AnimatedBuilder(animation: _floatAnim,
                    builder: (_, child) => Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
                    child: _GlowMascot()))),
                // Tap hint
                Positioned(top: 12, right: 14,
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), borderRadius: BorderRadius.circular(9)),
                    child: Text('TAP TO PET 👆', style: AppTextStyles.bold(9, Colors.white.withOpacity(0.6))))),
              ]))),
        ),

        const SizedBox(height: 12),

        // Animation buttons
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: List.generate(_anims.length, (i) {
            final on = _selAnim == i;
            return Expanded(child: Padding(padding: EdgeInsets.only(right: i < _anims.length - 1 ? 8 : 0),
              child: GestureDetector(onTap: () => setState(() => _selAnim = i),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: on ? AppColors.lavender.withOpacity(0.14) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: on ? Border.all(color: AppColors.lavender.withOpacity(0.3), width: 1) : null,
                  ),
                  child: Column(children: [
                    Text(_anims[i].$1, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 3),
                    Text(_anims[i].$2, style: AppTextStyles.caption(9, on ? AppColors.lavender : Colors.white.withOpacity(0.38))),
                  ])))));
          }))),

        const SizedBox(height: 10),

        // Save button
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTapDown: (_) => _saveCtrl.forward(),
            onTapUp:   (_) { _saveCtrl.reverse(); setState(() => _saved = !_saved); },
            onTapCancel: () => _saveCtrl.reverse(),
            child: AnimatedBuilder(animation: _saveScale,
              builder: (_, child) => Transform.scale(scale: _saveScale.value, child: child),
              child: AnimatedContainer(duration: const Duration(milliseconds: 300), height: 52,
                decoration: BoxDecoration(
                  gradient: _saved ? const LinearGradient(colors: [AppColors.mint, AppColors.sky]) : AppColors.lavGrad,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: (_saved ? AppColors.mint : AppColors.lavender).withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 8))],
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_saved ? '✅' : '✨', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(_saved ? 'Saved to My Zoo!' : 'Save to My Zoo', style: AppTextStyles.display(15, Colors.white)),
                ]))))),

        const SizedBox(height: 10),

        // Util row
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Row(children: [
            _UtilBtn(emoji: '📸', label: 'Shot',   onTap: () {}),
            const SizedBox(width: 8),
            _UtilBtn(emoji: '🎥', label: 'Record', onTap: () {}, gold: true),
            const SizedBox(width: 8),
            _UtilBtn(emoji: '📤', label: 'Share',  onTap: () {}),
          ])),
      ])),
    );
  }

  List<Widget> _rings() => [0.0, 0.85, 1.7].map((delay) => AnimatedBuilder(animation: _ringCtrl, builder: (_, __) {
    final phase = (_ringCtrl.value + delay / 2.5) % 1.0;
    return Positioned(bottom: 22, left: 0, right: 0, child: Center(child: Transform.scale(scale: 1 + phase * 1.8,
      child: Opacity(opacity: (1 - phase).clamp(0.0, 0.6),
        child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle,
          border: Border.all(color: AppColors.mint.withOpacity(0.4), width: 1.5)))))));
  })).toList();

  List<Widget> _particles() {
    final data = [(0.28, 55.0, AppColors.yolk, 0.0), (0.64, 65.0, AppColors.lavender, 0.3),
                  (0.45, 80.0, AppColors.coral, 0.6), (0.72, 50.0, AppColors.mint, 0.9)];
    return data.map((d) => LayoutBuilder(builder: (ctx, con) => AnimatedBuilder(animation: _particleCtrl, builder: (_, __) {
      final phase = (_particleCtrl.value + d.$4) % 1.0;
      return Positioned(left: con.maxWidth * d.$1, bottom: d.$2 - phase * 70,
        child: Opacity(opacity: (1 - phase).clamp(0.0, 1.0),
          child: Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: d.$3,
            boxShadow: [BoxShadow(color: d.$3.withOpacity(0.5), blurRadius: 4)]))));
    }))).toList();
  }
}

class _GlowMascot extends StatefulWidget {
  @override State<_GlowMascot> createState() => _GlowMascotState();
}
class _GlowMascotState extends State<_GlowMascot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _c,
    builder: (_, child) => Container(decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      BoxShadow(color: AppColors.mint.withOpacity(0.45 + _c.value * 0.2), blurRadius: 16 + _c.value * 10, spreadRadius: 2 + _c.value * 3),
      BoxShadow(color: AppColors.yolk.withOpacity(0.2 + _c.value * 0.1), blurRadius: 30 + _c.value * 15, spreadRadius: 5),
    ]), child: child),
    child: CustomPaint(size: const Size(75, 80), painter: MascotPainter(animValue: 0, glowColor: AppColors.mint)));
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.mint.withOpacity(0.07)..strokeWidth = 1;
    for (double y = 0; y <= size.height; y += 30) {
      final sc = 1 + (y / size.height) * 6;
      canvas.drawLine(Offset(size.width / 2 - size.width / 2 * sc, y), Offset(size.width / 2 + size.width / 2 * sc, y), p);
    }
    for (double x = 0; x <= size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(size.width / 2 + (x - size.width / 2) * 2, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _LiveBadge extends StatelessWidget {
  final Animation<double> anim;
  const _LiveBadge({required this.anim});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: AppColors.mint.withOpacity(0.12), borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.mint.withOpacity(0.3), width: 1)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(animation: anim, builder: (_, __) => Opacity(opacity: anim.value,
        child: Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.mint,
          boxShadow: [BoxShadow(color: AppColors.mint.withOpacity(0.5), blurRadius: 4)])))),
      const SizedBox(width: 6),
      Text('AR LIVE', style: AppTextStyles.bold(10, AppColors.mint)),
    ]));
}

class _UtilBtn extends StatelessWidget {
  final String emoji, label;
  final VoidCallback onTap;
  final bool gold;
  const _UtilBtn({required this.emoji, required this.label, required this.onTap, this.gold = false});
  @override
  Widget build(BuildContext context) => Expanded(child: GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: gold ? AppColors.yolk.withOpacity(0.08) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gold ? AppColors.yolk.withOpacity(0.25) : Colors.white.withOpacity(0.08), width: 1)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.bold(10, gold ? AppColors.yolk : Colors.white.withOpacity(0.45))),
      ]))));
}