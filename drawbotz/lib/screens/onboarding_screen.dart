import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/mascot_painter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  int _page = 0;

  final _pages = [
    _P('Draw it.',    'See it Live!',   'Scan your doodle & watch it walk around your room in AR ✨'),
    _P('Point &',     'Detect!',        'AI instantly recognises your character and prepares the magic 🔮'),
    _P('Watch it',    'Come Alive!',    'Your drawing runs, dances, and plays in your actual room 🎉'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: FadeTransition(opacity: _fade,
          child: SlideTransition(position: _slide,
            child: Column(children: [
              const LightStatusBar(),
              const SizedBox(height: 8),
              const AnimatedMascot(size: 160),
              const SizedBox(height: 8),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Column(key: ValueKey(_page), children: [
                  RichText(textAlign: TextAlign.center, text: TextSpan(children: [
                    TextSpan(text: '${_pages[_page].h1}\n', style: AppTextStyles.display(30, AppColors.ink)),
                    TextSpan(text: _pages[_page].h2,        style: AppTextStyles.display(30, AppColors.coral)),
                  ])),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Text(_pages[_page].sub, textAlign: TextAlign.center,
                        style: AppTextStyles.regular(13.5, AppColors.ink.withOpacity(0.52))),
                  ),
                ]),
              ),

              const SizedBox(height: 20),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: const [
                _Pill('🐉 Characters'), _Pill('🏠 AR Room'), _Pill('🎬 Animate'), _Pill('📤 Share'),
              ]),

              const Spacer(),
              PageDots(count: _pages.length, current: _page, activeColor: AppColors.coral),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  GradientButton(
                    label: 'Start Drawing Magic', emoji: '🎨',
                    gradient: AppColors.coralGrad,
                    onTap: () => Navigator.of(context).pushNamed('/camera'),
                  ),
                  const SizedBox(height: 12),
                  GhostButton(
                    label: 'How it works', emoji: '✏️',
                    onTap: () => setState(() => _page = (_page + 1) % _pages.length),
                  ),
                ]),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: AppColors.ink.withOpacity(0.07), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: AppTextStyles.bold(11, AppColors.ink.withOpacity(0.55))),
    );
  }
}

class _P {
  final String h1, h2, sub;
  const _P(this.h1, this.h2, this.sub);
}