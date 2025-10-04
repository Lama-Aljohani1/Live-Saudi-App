import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final popular = <_FoodItem>[
      _FoodItem('Dajaj biryani', 'assets/images/food/biryani.jpg', 4.6, 6),
      _FoodItem('Saudi harees', 'assets/images/food/harees.jpg', 4.5, 3),
    ];
    final favorite = <_FoodItem>[
      _FoodItem('Sambusati', 'assets/images/food/sambusati.jpg', 4.2, 2),
      _FoodItem('potato dish', 'assets/images/food/potato.jpg', 4.1, 3),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        _FoodSection(title: 'Popular Food', items: popular),
        const SizedBox(height: 12),
        _FoodSection(title: 'Favorite', items: favorite),
        const SizedBox(height: 12),
        _FoodSection(title: 'Favorite', items: favorite),
      ],
    );
  }
}

class _FoodItem {
  final String title;
  final String image;
  final double rating;
  final int ratingsCount;
  const _FoodItem(this.title, this.image, this.rating, this.ratingsCount);
}

class _FoodSection extends StatelessWidget {
  final String title;
  final List<_FoodItem> items;
  const _FoodSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('Show all', style: TextStyle(color: Colors.blue[700])),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _FoodThumb(item: items[i]),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 14, color: Colors.green),
            const SizedBox(width: 6),
            Text(
              'Tap a card to see more details.',
              style: TextStyle(color: cs.onSurface.withValues(alpha: .6)),
            ),
          ],
        ),
      ],
    );
  }
}

class _FoodThumb extends StatelessWidget {
  final _FoodItem item;
  const _FoodThumb({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(item.image, height: 80, width: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text('${item.rating}', style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text('(${item.ratingsCount})', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
