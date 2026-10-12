import 'package:flutter/material.dart';
import 'models.dart';

class Brand extends StatelessWidget {
  final bool light;
  const Brand({super.key, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(14),
          ),
          child:
              const Icon(Icons.egg_alt, color: AppColors.deepBrown, size: 28),
        ),
        const SizedBox(width: 12),
        Text(
          'EGG MACHA',
          style: TextStyle(
            color: light ? Colors.white : AppColors.brown,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const PrimaryButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.deepBrown,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const OutlineButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: .55)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final MenuItemModel item;
  final bool compact;
  const FoodCard({super.key, required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 18,
              offset: const Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.image, fit: BoxFit.cover),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: compact ? 15 : 17,
                        color: AppColors.brown)),
                if (!compact)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                  ),
                const SizedBox(height: 9),
                AnimatedBuilder(
                  animation: cart,
                  builder: (context, _) {
                    final quantity = cart.items[item] ?? 0;
                    if (quantity == 0) {
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => cart.add(item),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('ADD'),
                          style: FilledButton.styleFrom(
                              backgroundColor: AppColors.brown,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(38)),
                        ),
                      );
                    }
                    return Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => cart.remove(item),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$quantity in cart',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => cart.add(item),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return compact ? SizedBox(width: 250, child: card) : card;
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const SectionTitle(this.title, this.subtitle, {super.key});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: AppColors.brown)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: AppColors.muted))
      ]);
}

//Egg macha Special//
class MachaSpecialCard extends StatelessWidget {
  final MenuItemModel item;
  final bool compact;

  const MachaSpecialCard({super.key, required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        // Get the quantity for this specific menu item.
        final quantity = cart.items[item] ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.35),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 400;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // FOOD DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MACHA SPECIAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppColors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.deepBrown,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'A fragrant rice combo with rich egg curry.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.brown,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ADD OR QUANTITY BUTTONS
                        if (quantity == 0)
                          SizedBox(
                            width: compact ? double.infinity : 180,
                            child: ElevatedButton.icon(
                              onPressed: () => cart.add(item),
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                size: 17,
                              ),
                              label: const Text('ADD SPECIAL'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.deepBrown,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: AppColors.gold,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => cart.remove(item),
                                  icon: const Icon(Icons.remove),
                                  iconSize: 18,
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                  color: AppColors.brown,
                                ),
                                Text(
                                  '$quantity ADDED',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                    color: AppColors.deepBrown,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => cart.add(item),
                                  icon: const Icon(Icons.add),
                                  iconSize: 18,
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                  color: AppColors.brown,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // FOOD IMAGE ON THE RIGHT
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: compact ? 95 : 150,
                      height: compact ? 95 : 125,
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.white,
                          child: const Icon(
                            Icons.restaurant,
                            size: 40,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
