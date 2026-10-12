import 'package:egg_macha_frontend/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'landing.dart';
import 'models.dart';
import 'reusable_buttons.dart';

/// Staff can record daily shop operations here. Data is held in memory until a backend is connected.
class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});
  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  final completed = <String>{'Check opening area'};
  final tasks = const [
    'Check opening area',
    'Review new customer orders',
    'Confirm menu availability',
    'Record wastage',
    'Count closing stock',
    'Count cash box',
    'Clean and close work area'
  ];
  final Map<String, List<Map<String, String>>> records = {
    'Opening stock': [],
    'Purchases': [],
    'Sales': [],
    'Expenses': [],
    'Wastage': [],
    'Closing stock': [],
    'Cash box': [],
  };
  final Map<String, TextEditingController> openingControllers = {};
  bool dayClosed = false;

  Future<void> _addRecord(String type) async {
    final name = TextEditingController();
    final quantity = TextEditingController();
    final amount = TextEditingController();
    final notes = TextEditingController();
    final isStock = type.toLowerCase().contains('stock') || type == 'Wastage';
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Record $type'),
        content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  labelText: type == 'Cash box'
                      ? 'Cash count / denomination note'
                      : isStock
                          ? 'Item name'
                          : 'Description',
                  border: const OutlineInputBorder())),
          if (type != 'Cash box') ...[
            const SizedBox(height: 12),
            TextField(
                controller: quantity,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: isStock ? 'Quantity' : 'Quantity (optional)',
                    border: const OutlineInputBorder())),
          ],
          const SizedBox(height: 12),
          TextField(
              controller: amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: type == 'Closing stock'
                      ? 'Stock value (₹)'
                      : 'Amount (₹)',
                  border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: notes,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'Notes (optional)', border: OutlineInputBorder())),
        ])),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty || amount.text.trim().isEmpty) {
                  return;
                }
                Navigator.pop(dialogContext, {
                  'name': name.text.trim(),
                  'quantity': quantity.text.trim(),
                  'amount': amount.text.trim(),
                  'notes': notes.text.trim()
                });
              },
              child: const Text('Save entry'))
        ],
      ),
    );
    if (result != null && mounted) {
      setState(() {
        records[type]!.add(result);
        if (type == 'Closing stock') completed.add('Count closing stock');
        if (type == 'Cash box') completed.add('Count cash box');
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$type entry added')));
    }
    name.dispose();
    quantity.dispose();
    amount.dispose();
    notes.dispose();
  }

  double _total(String type) => records[type]!.fold(
      0, (sum, item) => sum + (double.tryParse(item['amount'] ?? '') ?? 0));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Egg Macha • Staff',
                style: TextStyle(fontWeight: FontWeight.w900)),
            actions: [
              IconButton(
                  tooltip: 'Logout',
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LandingPage()),
                      (_) => false),
                  icon: const Icon(Icons.logout))
            ]),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          const Text('STAFF WORKSPACE',
              style: TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
          const SizedBox(height: 8),
          const Text('Daily shop entries',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brown)),
          const SizedBox(height: 6),
          const Text(
              'Enter purchases, sales, stock, expenses and closing details for your shift.',
              style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          AdminPanel(
              title:
                  'DAILY ENTRY • ${records.values.fold<int>(0, (n, list) => n + list.length)} ENTRIES SAVED THIS SESSION',
              child: Column(children: [
                _EntryTile(
                    title: 'Opening stock',
                    subtitle: 'Record the opening count or value',
                    icon: Icons.inventory_2_outlined,
                    onTap: () => _addRecord('Opening stock')),
                _EntryTile(
                    title: 'Purchases',
                    subtitle:
                        '${records['Purchases']!.length} entries • ₹${_total('Purchases').toStringAsFixed(0)}',
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => _addRecord('Purchases')),
                _EntryTile(
                    title: 'Sales',
                    subtitle:
                        '${records['Sales']!.length} entries • ₹${_total('Sales').toStringAsFixed(0)}',
                    icon: Icons.point_of_sale_outlined,
                    onTap: () => _addRecord('Sales')),
                _EntryTile(
                    title: 'Closing stock',
                    subtitle: records['Closing stock']!.isEmpty
                        ? 'Not counted yet'
                        : '${records['Closing stock']!.length} count(s) recorded',
                    icon: Icons.egg_outlined,
                    onTap: () => _addRecord('Closing stock')),
                _EntryTile(
                    title: 'Expenses',
                    subtitle:
                        '${records['Expenses']!.length} entries • ₹${_total('Expenses').toStringAsFixed(0)}',
                    icon: Icons.receipt_long_outlined,
                    onTap: () => _addRecord('Expenses')),
                _EntryTile(
                    title: 'Wastage',
                    subtitle: '${records['Wastage']!.length} entries recorded',
                    icon: Icons.delete_outline,
                    onTap: () => _addRecord('Wastage')),
                _EntryTile(
                    title: 'Cash box',
                    subtitle: records['Cash box']!.isEmpty
                        ? 'Not counted'
                        : 'Cash count recorded',
                    icon: Icons.payments_outlined,
                    onTap: () => _addRecord('Cash box')),
              ])),
          const SizedBox(height: 16),
          AdminPanel(
              title:
                  'SHIFT CHECKLIST • ${completed.length}/${tasks.length} DONE',
              child: Column(
                  children: tasks
                      .map((task) => CheckboxListTile(
                            value: completed.contains(task),
                            title: Text(task),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) => setState(() {
                              if (value == true) {
                                completed.add(task);
                              } else {
                                completed.remove(task);
                              }
                            }),
                          ))
                      .toList())),
          const SizedBox(height: 16),
          const AdminPanel(title: 'TODAY’S ORDERS', child: OrderTable()),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.orange)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Close the day',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.brown)),
                    const SizedBox(height: 6),
                    Text(
                        dayClosed
                            ? 'Day marked as closed on this device.'
                            : '${completed.length} of ${tasks.length} checklist steps done.',
                        style: const TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 12),
                    SizedBox(
                        width: double.infinity,
                        child: AppButton(
                            label: dayClosed ? 'DAY CLOSED' : 'CLOSE THE DAY',
                            icon: Icons.check_circle_outline,
                            fullWidth: true,
                            onPressed: dayClosed
                                ? () {}
                                : () {
                                    if (records['Closing stock']!.isEmpty ||
                                        records['Cash box']!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Please record Closing stock and Cash box before closing the day.')));
                                      return;
                                    }
                                    setState(() {
                                      dayClosed = true;
                                      completed
                                          .add('Clean and close work area');
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Day marked closed for this session.')));
                                  })),
                  ])),
          const SizedBox(height: 16),
          const Text(
              'Demo mode: entries stay on this screen only and reset when the app restarts. Connect a backend/database for permanent records and secure staff permissions.',
              style: TextStyle(color: AppColors.muted)),
        ]),
      );
}

class _EntryTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _EntryTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.only(bottom: 9),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.cream)),
      child: ListTile(
        leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3D2),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.brown)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ));
}
