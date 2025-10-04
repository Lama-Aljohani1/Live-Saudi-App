import 'package:flutter/material.dart';
import 'food_home_screen.dart';

class RestaurantsListScreen extends StatelessWidget {
  const RestaurantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <_Restaurant>[
      _Restaurant('Bayt Al-Ma’soub', 'Jeddah', 4.6, 'assets/images/food/bayt.jpg'),
      _Restaurant('Um Abdullah’s Kitchen', 'Jeddah', 4.7, 'assets/images/food/um_abdullah.jpg'),
      _Restaurant('Hejazi Heritage', 'Jeddah', 4.6, 'assets/images/food/hejazi.jpg'),
      _Restaurant('Old Days Kitchen', 'Jeddah', 4.5, 'assets/images/food/old_days.jpg'),
      _Restaurant('Baharat Zaman', 'Jeddah', 4.5, 'assets/images/food/baharat.jpg'),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _RestaurantTile(r: data[i]),
    );
  }
}

class _Restaurant {
  final String name;
  final String city;
  final double rating;
  final String image;
  const _Restaurant(this.name, this.city, this.rating, this.image);
}

class _RestaurantTile extends StatelessWidget {
  final _Restaurant r;
  const _RestaurantTile({required this.r});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(r.image, width: 92, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place_rounded, size: 16, color: kPrimary),
                      const SizedBox(width: 4),
                      Text(r.city, style: TextStyle(color: cs.onSurface.withValues(alpha: .7))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('${r.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
