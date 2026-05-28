
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class MyZooScreen extends StatefulWidget {
  const MyZooScreen({super.key});
  @override State<MyZooScreen> createState() => _MyZooScreenState();
}

class _MyZooScreenState extends State<MyZooScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  int _filter = 0;
  final _filters = ['All', 'Dragons', 'Monsters', 'Animals'];
  final _creatures = [
    _C('Drago',   'Dragon',  'Today',     AppColors.coral,    '🐉', 'Dance'),
    _C('Blobby',  'Monster', 'Yesterday', AppColors.lavender, '👾', 'Run'),
    _C('Fuzzy',   'Animal',  'Mon',       AppColors.mint,     '🐻', 'Wave'),
    _C('Sparky',  'Dragon',  'Sun',       AppColors.yolk,     '⚡', 'Jump'),
    _C('Gloomy',  'Monster', 'Fri',       AppColors.sky,      '🌊', 'Dance'),
    _C('Pebble',  'Animal',  'Thu',       AppColors.coral,    '🐢', 'Sleep'),
  ];

  List<_C> get _shown => _filter == 0 ? _creatures : _creatures.where((c) => c.tag == _filters[_filter]).toList();

  @override
  void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600)); _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut); _ctrl.forward(); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      floatingActionButton: GestureDetector(onTap: () => Navigator.of(context).pushNamed('/camera'),
        child: Container(width: 58, height: 58,
          decoration: BoxDecoration(gradient: AppColors.coralGrad, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.coral.withOpacity(0.45), blurRadius: 18, offset: const Offset(0, 8))]),
          child: const Center(child: Text('🎨', style: TextStyle(fontSize: 26))))),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGrad),
        child: SafeArea(child: FadeTransition(opacity: _fade,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const DarkStatusBar(),

            // Header
            Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(children: [
                IconCircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop()),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('My Zoo 🐾', style: AppTextStyles.display(22, Colors.white)),
                  Text('${_creatures.length} creatures collected', style: AppTextStyles.regular(12, Colors.white.withOpacity(0.4))),
                ]),
                const Spacer(),
                IconCircleButton(emoji: '➕', onTap: () => Navigator.of(context).pushNamed('/camera'),
                    bgColor: AppColors.coral.withOpacity(0.15), borderColor: AppColors.coral.withOpacity(0.3)),
              ])),

            const SizedBox(height: 18),

            // Stats
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _Stat('6',  'Doodles',    AppColors.coral),
                const SizedBox(width: 10),
                _Stat('14', 'AR Sessions', AppColors.mint),
                const SizedBox(width: 10),
                _Stat('3',  'Shared',     AppColors.lavender),
              ])),

            const SizedBox(height: 18),

            // Filters
            SizedBox(height: 36, child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => AppChip(label: _filters[i], color: AppColors.lavender,
                isSelected: _filter == i, onTap: () => setState(() => _filter = i)),
            )),

            const SizedBox(height: 16),

            // Grid
            Expanded(child: _shown.isEmpty ? _Empty() : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.82),
              itemCount: _shown.length,
              itemBuilder: (_, i) => _Card(creature: _shown[i]),
            )),
          ])))),
    );
  }
}

class _Stat extends StatelessWidget {
  final String val, lbl; final Color color;
  const _Stat(this.val, this.lbl, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1)),
    child: Column(children: [
      Text(val, style: AppTextStyles.display(24, color)),
      const SizedBox(height: 2),
      Text(lbl, style: AppTextStyles.bold(10, color.withOpacity(0.6)), textAlign: TextAlign.center),
    ])));
}

class _Card extends StatefulWidget {
  final _C creature;
  const _Card({required this.creature});
  @override State<_Card> createState() => _CardState();
}
class _CardState extends State<_Card> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 150)); _s = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.creature;
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp:   (_) { _c.reverse(); Navigator.of(context).pushNamed('/ar'); },
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(animation: _s,
        builder: (_, child) => Transform.scale(scale: _s.value, child: child),
        child: Container(
          decoration: BoxDecoration(color: AppColors.inkSoft, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.color.withOpacity(0.25), width: 1.5),
            boxShadow: [BoxShadow(color: c.color.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 6))]),
          child: Column(children: [
            Expanded(child: Container(width: double.infinity,
              decoration: BoxDecoration(color: c.color.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
              child: Stack(alignment: Alignment.center, children: [
                Text(c.emoji, style: TextStyle(fontSize: 64, shadows: [Shadow(color: c.color.withOpacity(0.3), blurRadius: 20)])),
                Positioned(top: 10, right: 10, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.ink.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                  child: Text('AR', style: AppTextStyles.bold(9, c.color)))),
              ]))),
            Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(c.name, style: AppTextStyles.display(14, Colors.white))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: c.color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(c.anim, style: AppTextStyles.bold(8, c.color))),
                ]),
                const SizedBox(height: 3),
                Row(children: [
                  Text(c.tag,  style: AppTextStyles.regular(10, Colors.white.withOpacity(0.4))),
                  const Spacer(),
                  Text(c.date, style: AppTextStyles.regular(10, Colors.white.withOpacity(0.3))),
                ]),
              ])),
          ]))));
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Text('🦕', style: TextStyle(fontSize: 64)),
    const SizedBox(height: 16),
    Text('No creatures yet!', style: AppTextStyles.display(18, Colors.white.withOpacity(0.6))),
    const SizedBox(height: 8),
    Text('Draw one and scan it!', style: AppTextStyles.regular(13, Colors.white.withOpacity(0.35))),
  ]));
}

class _C {
  final String name, tag, date, emoji, anim; final Color color;
  const _C(this.name, this.tag, this.date, this.color, this.emoji, this.anim);
}