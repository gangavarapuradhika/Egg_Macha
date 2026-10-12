import 'package:flutter/material.dart';
import 'reusable_cards.dart';

class BusinessManagementPage extends StatefulWidget {
  const BusinessManagementPage({super.key});
  @override
  State<BusinessManagementPage> createState() => _BusinessManagementPageState();
}

class _BusinessManagementPageState extends State<BusinessManagementPage> {
  final records = <String, int>{
    'Daily entries': 0,
    'Purchases': 0,
    'Sales': 0,
    'Expenses': 0,
    'Wastage': 0,
    'Closing stock': 0,
    'Cash box': 0
  };
  final items = const [
    _BusinessItem('Daily entries', 'Opening stock, sales and closing checklist',
        Icons.today),
    _BusinessItem('Stock flow', 'Track stock received, sold and adjusted',
        Icons.swap_vert),
    _BusinessItem('Inventory', 'Ingredients, quantities and low-stock checks',
        Icons.inventory_2_outlined),
    _BusinessItem('Purchases', 'Record supplier purchases and bills',
        Icons.shopping_bag_outlined),
    _BusinessItem(
        'Sales', 'Enter daily sales and payment totals', Icons.point_of_sale),
    _BusinessItem('Expenses', 'Track rent, utilities and other expenses',
        Icons.receipt_long),
    _BusinessItem('Wastage', 'Record damaged or wasted ingredients',
        Icons.delete_outline),
    _BusinessItem('Profit & loss', 'Review sales, costs and estimated profit',
        Icons.query_stats),
    _BusinessItem('Reports', 'Daily and monthly summaries', Icons.bar_chart),
    _BusinessItem(
        'Employees', 'Staff list and shift checklist', Icons.groups_outlined),
    _BusinessItem('Settings', 'Business preferences and opening hours',
        Icons.settings_outlined),
    _BusinessItem(
        'Audit log', 'Review changes recorded in this demo', Icons.history),
  ];
  void addEntry(String title) {
    final amount = TextEditingController();
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: Text('Add $title entry'),
                content: TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Amount / quantity',
                        border: OutlineInputBorder())),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('CANCEL')),
                  FilledButton(
                      onPressed: () {
                        setState(
                            () => records[title] = (records[title] ?? 0) + 1);
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('$title entry added to this demo.')));
                      },
                      child: const Text('SAVE'))
                ]));
  }

  @override
  Widget build(BuildContext context) => Container(
      color: const Color(0xFF0B1018),
      child: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('BUSINESS MANAGEMENT',
            style: TextStyle(
                color: Color(0xFFFFC83D),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5)),
        const SizedBox(height: 8),
        const Text('Daily operations',
            style: TextStyle(
                color: Color(0xFFF8F3E8),
                fontSize: 30,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('A quick view of stock, money and shift activities.',
            style: TextStyle(color: Color(0xFF9AA4B2))),
        const SizedBox(height: 18),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _summary('Today’s sales', '₹0'),
          _summary('Today’s spend', '₹0'),
          _summary('Estimated profit', '—')
        ]),
        const SizedBox(height: 20),
        const Text('OPERATIONS',
            style: TextStyle(
                color: Color(0xFF9AA4B2),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                mainAxisExtent: 145,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
            itemBuilder: (context, i) {
              final item = items[i];
              return AppCard(
                  onTap: () => _open(item),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(item.icon,
                            color: i == 0
                                ? const Color(0xFFFFC83D)
                                : const Color(0xFFF8F3E8),
                            size: 26),
                        const Spacer(),
                        Text(item.title,
                            style: const TextStyle(
                                color: Color(0xFFF8F3E8),
                                fontSize: 17,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(item.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color(0xFF9AA4B2), fontSize: 12))
                      ]));
            }),
        const SizedBox(height: 18),
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFF29251C),
                border: Border.all(color: const Color(0xFF79612A)),
                borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              const Icon(Icons.check_circle_outline,
                  color: Color(0xFFFFC83D), size: 28),
              const SizedBox(width: 12),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Close the day',
                        style: TextStyle(
                            color: Color(0xFFF8F3E8),
                            fontWeight: FontWeight.w900,
                            fontSize: 17)),
                    Text('Complete sales, stock, expenses and cash count.',
                        style: TextStyle(color: Color(0xFFB7B2A7)))
                  ])),
              TextButton(
                  onPressed: () => addEntry('Daily entries'),
                  child: const Text('OPEN'))
            ])),
        const SizedBox(height: 12),
        const Text(
            'Demo only: entries are held in memory and will reset when the app restarts. A backend/database is needed for saved records, staff permissions and accurate financial reports.',
            style: TextStyle(color: Color(0xFF9AA4B2), fontSize: 12)),
      ]));
  Widget _summary(String title, String value) => Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFF151C27),
          border: Border.all(color: const Color(0xFF2A3442)),
          borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(color: Color(0xFF9AA4B2), fontSize: 12)),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                color: Color(0xFFFFC83D),
                fontSize: 22,
                fontWeight: FontWeight.w900))
      ]));
  void _open(_BusinessItem item) {
    if ([
      'Daily entries',
      'Purchases',
      'Sales',
      'Expenses',
      'Wastage',
      'Closing stock',
      'Cash box'
    ].contains(item.title)) {
      addEntry(item.title == 'Daily entries' ? 'Daily entries' : item.title);
      return;
    }
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
                title: Text(item.title),
                content: Text(
                    '${item.subtitle}\n\nThis section is ready as a UI placeholder. Connect your database to save and display real ${item.title.toLowerCase()} records.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text('CLOSE'))
                ]));
  }
}

class _BusinessItem {
  final String title, subtitle;
  final IconData icon;
  const _BusinessItem(this.title, this.subtitle, this.icon);
}
