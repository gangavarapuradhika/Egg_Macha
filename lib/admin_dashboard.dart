import 'package:flutter/material.dart';
import 'landing.dart';
import 'models.dart';
import 'widgets.dart';
import 'business_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int index = 0;

  final List<String> labels = const [
    'Overview',
    'Orders',
    'Menu Manager',
    'Customers',
    'Events',
    'Settings',
    'Business Management',
  ];

  final List<IconData> icons = const [
    Icons.dashboard,
    Icons.receipt_long,
    Icons.restaurant_menu,
    Icons.people,
    Icons.event,
    Icons.settings,
    Icons.storefront,
  ];

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LandingPage()),
      (_) => false,
    );
  }

  Widget _getContent() {
    if (index == 6) {
      return const BusinessManagementPage();
    }
    return AdminContent(index: index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth > 900;
        final Widget content = _getContent();

        // DESKTOP LAYOUT
        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 245,
                  color: AppColors.deepBrown,
                  padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Brand(light: true),
                      const SizedBox(height: 38),
                      ...List.generate(
                        labels.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ListTile(
                            selected: index == i,
                            selectedTileColor: AppColors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            iconColor:
                                index == i ? AppColors.brown : Colors.white70,
                            textColor:
                                index == i ? AppColors.brown : Colors.white70,
                            leading: Icon(icons[i]),
                            title: Text(labels[i]),
                            onTap: () {
                              setState(() {
                                index = i;
                              });
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      ListTile(
                        textColor: Colors.white70,
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    child: content,
                  ),
                ),
              ],
            ),
          );
        }

        // MOBILE LAYOUT
        final int mobileIndex = index >= 4 ? 3 : index;

        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: ListView(
                children: [
                  const ListTile(
                    title: Text(
                      'EGG MACHA ADMIN',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ...List.generate(
                    labels.length,
                    (i) => ListTile(
                      leading: Icon(icons[i]),
                      title: Text(labels[i]),
                      selected: index == i,
                      onTap: () {
                        setState(() {
                          index = i;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              labels[index],
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(ctx).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Business management',
                onPressed: () {
                  setState(() {
                    index = 6;
                  });
                },
                icon: const Icon(Icons.storefront),
              ),
            ],
          ),
          body: SafeArea(
            child: content,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: mobileIndex,
            onDestinationSelected: (i) {
              setState(() {
                index = i;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.restaurant),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: Icon(Icons.people),
                label: 'Users',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ADMIN CONTENT

class AdminContent extends StatelessWidget {
  final int index;

  const AdminContent({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 1:
        return const AdminOrders();

      case 2:
        return const AdminMenu();

      case 4:
        return const AdminEvents();

      case 6:
        return const BusinessManagementPage();

      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == 0
                    ? 'GOOD AFTERNOON, ADMIN 👋'
                    : index == 3
                        ? 'CUSTOMERS'
                        : 'SETTINGS',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Manage your restaurant frontend.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 25),
              if (index == 0) ...[
                const Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _Stat(
                      '₹0',
                      'Today sales',
                      Icons.payments,
                      AppColors.green,
                    ),
                    _Stat(
                      '0',
                      'Orders',
                      Icons.receipt_long,
                      AppColors.orange,
                    ),
                    _Stat(
                      '0',
                      'Active customers',
                      Icons.people,
                      AppColors.red,
                    ),
                    _Stat(
                      '8',
                      'Menu items',
                      Icons.restaurant,
                      AppColors.brown,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const AdminPanel(
                  title: 'LIVE ORDER FLOW',
                  child: OrderTable(),
                ),
              ],
              if (index == 3)
                const AdminPanel(
                  title: 'CUSTOMER LIST',
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'No customer records yet. Connect the backend '
                      'to load registered customers.',
                    ),
                  ),
                ),
              if (index == 5)
                const AdminPanel(
                  title: 'APP SETTINGS',
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: true,
                        onChanged: null,
                        title: Text('Accept online orders'),
                      ),
                      SwitchListTile(
                        value: true,
                        onChanged: null,
                        title: Text('Show Macha Special'),
                      ),
                      ListTile(
                        title: Text('Opening hours'),
                        subtitle: Text(
                          '4 PM – 11 PM • Monday holiday',
                        ),
                        trailing: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
    }
  }
}

// DASHBOARD STATISTICS

class _Stat extends StatelessWidget {
  final String value;
  final String title;
  final IconData icon;
  final Color color;

  const _Stat(
    this.value,
    this.title,
    this.icon,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// REUSABLE ADMIN PANEL

class AdminPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const AdminPanel({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ORDER TABLE

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orderStore,
      builder: (context, _) {
        final orders = orderStore.orders;

        if (orders.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'No orders yet. New customer orders will appear here '
              'after backend integration.',
            ),
          );
        }

        return Column(
          children: orders.map((order) {
            return ListTile(
              leading: const Icon(
                Icons.receipt_long,
                color: AppColors.orange,
              ),
              title: Text('Order #${order.id}'),
              subtitle: Text(
                order.lines
                    .map((line) => '${line.name} × ${line.quantity}')
                    .join(' • '),
              ),
              trailing: Text(
                '₹${order.total.toStringAsFixed(0)}',
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ADMIN ORDERS PAGE

class AdminOrders extends StatelessWidget {
  const AdminOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER MANAGEMENT',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          AdminPanel(
            title: 'ORDERS',
            child: OrderTable(),
          ),
        ],
      ),
    );
  }
}

// ADMIN MENU PAGE

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'MENU MANAGER',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              PrimaryButton(
                label: 'ADD ITEM',
                icon: Icons.add,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...menuItems.map(
            (m) => Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    m.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  m.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  '${m.category} • ₹${m.price.toStringAsFixed(0)}',
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// EVENTS PAGE

class AdminEvents extends StatelessWidget {
  const AdminEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EVENTS & COMMUNITY',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          EventCard(
            title: 'WEEKEND MACHA SPECIAL',
            description: 'A rotating dish worth coming back for.',
            date: 'Saturday • 7 PM',
          ),
          EventCard(
            title: 'FRIENDS AT THE TAWA',
            description: 'Food, conversations and your people.',
            date: 'Sunday • 6 PM',
          ),
          EventCard(
            title: 'FIRST BITE CLUB',
            description: 'Be the first to taste a new experiment.',
            date: 'Coming soon',
          ),
        ],
      ),
    );
  }
}

// EVENT CARD

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.cream,
          child: Icon(
            Icons.event,
            color: AppColors.orange,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Text('$description\n$date'),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
