import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'models.dart';
import 'widgets.dart';
import 'customer_shell.dart' show CartSheet;

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 700;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HERO BANNER
              Container(
                height: wide ? 330 : 260,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.deepBrown,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/omelette.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.deepBrown),
                    ),
                    Container(
                      color: AppColors.deepBrown.withValues(alpha: 0.55),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'EGGS.',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'BUT NOT ORDINARY.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: wide ? 40 : 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Freshly cooked. Macha style.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            label: 'ORDER NOW',
                            icon: Icons.arrow_forward,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const MenuPage(standalone: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // FAVOURITES
              const SectionTitle(
                'FAVOURITES',
                'Choose your favourite egg dishes.',
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: menuItems.take(8).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: SizedBox(
                        width: 235,
                        child: FoodCard(
                          item: item,
                          compact: true,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // MACHA SPECIAL
              const SectionTitle(
                'MACHA SPECIAL',
                'Our signature combo — add it to your cart just like any other menu item.',
              ),

              const SizedBox(height: 14),

              MachaSpecialCard(item: menuItems[4]),

              const SizedBox(height: 24),

              // CART SUMMARY
              AnimatedBuilder(
                animation: cart,
                builder: (context, _) => Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.brown,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'YOUR CART',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: AppColors.brown,
                              ),
                            ),
                            Text(
                              '${cart.count} item(s) · ₹${cart.total.toStringAsFixed(0)}',
                            ),
                          ],
                        ),
                      ),
                      if (cart.count > 0)
                        TextButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const CartSheet(),
                          ),
                          child: const Text('VIEW CART'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
