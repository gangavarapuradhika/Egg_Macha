import 'package:flutter/material.dart';
import 'models.dart';
import 'address_page.dart';
import 'widgets.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orderStore,
      builder: (context, _) {
        final orders = orderStore.orders;
        if (orders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 72, color: AppColors.orange),
                  const SizedBox(height: 16),
                  const Text('NO ORDERS YET',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.brown)),
                  const SizedBox(height: 8),
                  const Text(
                      'Your new orders and tracking updates will appear here after checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Browse menu'),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.deepBrown),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('MY ORDERS',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brown)),
            const SizedBox(height: 6),
            const Text('Track orders you have placed.',
                style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 18),
            ...orders.map((order) => Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OrderTrackingPage(order: order))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                  backgroundColor: AppColors.cream,
                                  child: Icon(Icons.receipt_long,
                                      color: AppColors.orange)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text('Order #${order.id}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17))),
                              Text('₹${order.total.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...order.lines.map((line) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(line.name)),
                                    Text('× ${line.quantity}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(width: 12),
                                    Text(
                                        '₹${line.subtotal.toStringAsFixed(0)}'),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(Icons.local_dining,
                                  color: AppColors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(order.status,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800))),
                              const Text('Track order  ›',
                                  style: TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}

class OrderTrackingPage extends StatelessWidget {
  final CustomerOrder order;
  const OrderTrackingPage({super.key, required this.order});

  static const steps = [
    ('Order placed', 'We have received your order.', Icons.receipt_long),
    (
      'Confirmed',
      'The restaurant confirms your order.',
      Icons.thumb_up_alt_outlined
    ),
    (
      'Preparing',
      'Your food is being freshly prepared.',
      Icons.soup_kitchen_outlined
    ),
    (
      'Ready for pickup/delivery',
      'Your order is ready for the next step.',
      Icons.inventory_2_outlined
    ),
    ('Completed', 'Enjoy your meal!', Icons.check_circle_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('ORDER #${order.id}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brown)),
          const SizedBox(height: 6),
          Text(
              'Placed ${order.createdAt.toLocal().toString().substring(0, 16)}'),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ITEMS IN THIS ORDER',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  ...order.lines.map((line) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(line.name)),
                            Text('× ${line.quantity}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(width: 12),
                            Text('₹${line.subtotal.toStringAsFixed(0)}'),
                          ],
                        ),
                      )),
                  const Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        Text('₹${order.total.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900)),
                      ]),
                ],
              ),
            ),
          ),
          if (order.deliveryAddress.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
                child: ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: AppColors.orange),
                    title: const Text('DELIVERY ADDRESS',
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(order.deliveryAddress))),
          ],
          const SizedBox(height: 24),
          const Text('TRACKING STATUS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (i) {
            final current = i == 0;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: current ? AppColors.orange : AppColors.cream,
                child: Icon(steps[i].$3,
                    color: current ? AppColors.deepBrown : AppColors.muted),
              ),
              title: Text(steps[i].$1,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: current ? AppColors.brown : AppColors.muted)),
              subtitle: Text(
                  current ? 'Current status · ${steps[i].$2}' : steps[i].$2),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'Tracking is a frontend placeholder. Live status updates will come from your backend when connected.',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('MY PROFILE',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brown)),
          const SizedBox(height: 20),
          const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.orange,
              child: Icon(Icons.person, size: 42, color: AppColors.brown)),
          const SizedBox(height: 15),
          const Text('Your profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const Text('Manage your saved delivery addresses here.',
              style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 25),
          AnimatedBuilder(
              animation: addressStore,
              builder: (context, _) => Card(
                      child: ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: AppColors.orange),
                    title: const Text('Saved delivery addresses',
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(addressStore.addresses.isEmpty
                        ? 'No address saved yet'
                        : '${addressStore.addresses.length} saved address(es) · ${addressStore.selected?.formatted ?? 'Choose an address'}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AddressPage())),
                  ))),
          const SizedBox(height: 12),
          PrimaryButton(
              label: 'MANAGE ADDRESSES',
              icon: Icons.edit_location_alt_outlined,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddressPage()))),
          const SizedBox(height: 20),
          const Card(
              child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Account details'),
                  subtitle: Text(
                      'Connect your user database to display profile details.'))),
          const SizedBox(height: 12),
          const Text(
              'Frontend preview: saved addresses are kept in memory and reset when the app restarts. Permanent address storage will be added with the backend/database.',
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      );
}
