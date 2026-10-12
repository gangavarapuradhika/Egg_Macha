import 'package:flutter/material.dart';
import 'customer_home.dart';
import 'menu_page.dart';
import 'orders_profile.dart';
import 'models.dart';
import 'widgets.dart';
import 'address_page.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int index = 0;
  final pages = const [CustomerHome(), MenuPage(), OrdersPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Brand(),
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (_, __) => cart.count == 0
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Badge(
                      label: Text('${cart.count}'),
                      child: IconButton(
                        tooltip: 'Open cart',
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const CartSheet(),
                        ),
                        icon: const Icon(Icons.shopping_bag),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Menu'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Orders'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}

class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cart,
      builder: (_, __) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('YOUR CART',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brown)),
              const SizedBox(height: 8),
              const Text('Change quantities here before placing your order.'),
              const SizedBox(height: 16),
              if (cart.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                      child:
                          Text('Your cart is empty. Add items from the menu.')),
                ),
              ...cart.items.entries.map((entry) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.key.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '₹${entry.key.price.toStringAsFixed(0)} each  •  Subtotal ₹${(entry.key.price * entry.value).toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => cart.remove(entry.key),
                            icon: const Icon(Icons.remove_circle_outline)),
                        Text('${entry.value}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                        IconButton(
                            onPressed: () => cart.add(entry.key),
                            icon: const Icon(Icons.add_circle_outline)),
                      ],
                    ),
                  )),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined,
                    color: AppColors.orange),
                title: const Text('DELIVERY ADDRESS',
                    style: TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(addressStore.selected?.formatted ??
                    'Choose or add your delivery address at checkout'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<DeliveryAddress>(
                        builder: (_) =>
                            const AddressPage(selectForCheckout: true))),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  Text('₹${cart.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'PLACE ORDER',
                  icon: Icons.check_circle,
                  onTap: () {
                    if (cart.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Add at least one item first.')));
                      return;
                    }
                    Navigator.of(context)
                        .push(MaterialPageRoute<DeliveryAddress>(
                            builder: (_) =>
                                const AddressPage(selectForCheckout: true)))
                        .then((address) {
                      if (address == null || !context.mounted) return;
                      final order = orderStore.createFromCart(cart,
                          deliveryAddress: address.formatted);
                      cart.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Order #${order.id} placed. Open Orders to track it.')));
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Frontend preview: orders are stored in memory only and will reset when the app restarts. Backend/database integration can be added later.',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
