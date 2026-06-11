import 'package:flutter/material.dart';
import 'package:formative_assignment1/theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  static const _items = [
    _NavItemData(icon: Icons.home_outlined,        label: 'Home',        route: '/home'),
    _NavItemData(icon: Icons.explore_outlined,     label: 'Explore',     route: '/explore'),
    _NavItemData(icon: Icons.add_circle_outline,   label: 'Create',      route: '/create'),
    _NavItemData(icon: Icons.chat_bubble_outline,  label: 'Chats',       route: '/chats'),
    _NavItemData(icon: Icons.person_outline,       label: 'Profile',     route: '/profile'),
    _NavItemData(icon: Icons.group_outlined,       label: 'Communities', route: '/communities'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.white,
      elevation: 8,
      shadowColor: const Color(0x33000000),
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 65,
        child: Row(
          children: List.generate(
            _items.length,
            (i) => _NavItem(
              data: _items[i],
              selected: currentIndex == i,
              onTap: () {
                if (currentIndex != i) {
                  Navigator.pushReplacementNamed(context, _items[i].route);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _NavItemData {
  const _NavItemData(
      {required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;
}

// ── Single item ───────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.data, required this.selected, required this.onTap});

  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: selected
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 5)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(data.icon, color: color, size: 20),
            ),
            const SizedBox(height: 3),
            Text(
              data.label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
