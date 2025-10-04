import 'package:flutter/material.dart';
import 'food_home_screen.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'Browse the menu here, then',
          style: TextStyle(color: cs.onSurface.withValues(alpha: .7), fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          'Order Now',
          style: TextStyle(color: kPrimary, fontWeight: FontWeight.w800, fontSize: 28),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: const AssetImage('assets/images/food/contact.jpg'),
                backgroundColor: Colors.grey.withValues(alpha: .2),
              ),
              const SizedBox(height: 16),
              const Text('xxxxxxxxxxxxxxx', style: TextStyle(letterSpacing: 1.2)),
              const Text('xxxxxxxx', style: TextStyle(letterSpacing: 1.2)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _ActionIcon(icon: Icons.phone_rounded),
                  SizedBox(width: 16),
                  _ActionIcon(icon: Icons.chat_bubble_rounded),
                  SizedBox(width: 16),
                  _ActionIcon(icon: Icons.camera_alt_rounded),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: kPrimary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
