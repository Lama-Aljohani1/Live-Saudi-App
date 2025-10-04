import 'package:flutter/material.dart';
import '../food/food_home_screen.dart';

const kPrimary = Color(0xFF4C643E);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // <-- النصوص يسار
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, size: 28, color: Colors.black87),
                  Text(
                    "Jeddah, Saudi Arabia",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/images/avatar.jpg"),
                  ),
                ],
              ),
            ),

            // Greeting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi Ahmad,",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Where do you\nwanna go?",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Featured image slider (مثال صورة واحدة مؤقتاً)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage("assets/images/mosque.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "See More",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategoryChip(label: "Popular", active: true),
                  _CategoryChip(label: "Lake"),
                  _CategoryChip(label: "Beach"),
                  _CategoryChip(label: "Mountain"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Activities (scroller)
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _PlaceCard(
                    image: "assets/images/beitbaeshen.jpg",
                    title: "Beit Baeshen",
                    rating: 4.8,
                  ),
                  _PlaceCard(
                    image: "assets/images/teamlab.webp",
                    title: "TeamLab Borderless",
                    rating: 4.9,
                  ),
                  _PlaceCard(
                    image: "assets/images/alsharbatly.jpg",
                    title: "Al Sharbatly House",
                    rating: 4.7,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home
                _NavIcon(icon: Icons.home_rounded, active: true, onTap: () {}),

                // Explore (أيقونة ثانية عادية)
                _NavIcon(icon: Icons.circle_outlined, onTap: () {}),

                // === Food زر الفود (مهم) ===
                _NavIcon(
                  icon: Icons.restaurant_menu_rounded,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FoodHomeScreen()),
                    );
                  },
                ),

                // Profile
                _NavIcon(icon: Icons.person_rounded, onTap: () {}),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

// ===== Widgets =====

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;
  const _CategoryChip({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? kPrimary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? kPrimary : Colors.black26,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String image;
  final String title;
  final double rating;
  const _PlaceCard(
      {required this.image, required this.title, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black54, blurRadius: 4),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;
  const _NavIcon({required this.icon, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: active ? kPrimary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: active ? Colors.white : Colors.black54,
          size: 26,
        ),
      ),
    );
  }
}
