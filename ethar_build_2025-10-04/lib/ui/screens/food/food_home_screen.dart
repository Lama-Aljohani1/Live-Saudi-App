import 'package:flutter/material.dart';
import 'restaurants_list_screen.dart';
import 'menu_screen.dart';
import 'connect_screen.dart';

const kPrimary = Color(0xFF4C643E);

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const _FoodHeader(),
              const SizedBox(height: 8),
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    labelColor: kPrimary,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(text: 'Restaurants'),
                      Tab(text: 'Popular'),
                      Tab(text: 'Order Now'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: TabBarView(
                  children: [
                    RestaurantsListScreen(),
                    MenuScreen(),
                    ConnectScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Bottom bar شكله مطابق للتصميم
        bottomNavigationBar: const _BottomBar(activeIndex: 2),
      ),
    );
  }
}

class _FoodHeader extends StatelessWidget {
  const _FoodHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.menu_rounded, size: 28, color: kPrimary),
          ),
          const Spacer(),
          Text(
            'Jeddah, Saudi Arabia',
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: .6),
              fontSize: 15,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int activeIndex; // 0: home, 1: explore, 2: food, 3: profile
  const _BottomBar({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    Color iconColor(int i) => i == activeIndex ? Colors.white : Colors.black54;
    Color bg(int i) => i == activeIndex ? kPrimary : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circleIcon(Icons.home_rounded, bg(0), iconColor(0)),
              _circleIcon(Icons.brightness_low_rounded, bg(1), iconColor(1)),
              _circleIcon(Icons.favorite_rounded, bg(2), iconColor(2)),
              _circleIcon(Icons.person_rounded, bg(3), iconColor(3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, Color bg, Color fg) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: fg, size: 26),
    );
  }
}
