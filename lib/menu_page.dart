import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets.dart';

class MenuPage extends StatefulWidget {
  final bool standalone;
  const MenuPage({super.key, this.standalone = false});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String category = 'All';
  final categories = const [
    'All',
    'Omelettes',
    'Egg Pav',
    'Maggi',
    'Sandwiches',
    'Meals',
    'Half Boiled'
  ];

  @override
  Widget build(BuildContext context) {
    final data = category == 'All'
        ? menuItems
        : menuItems.where((item) => item.category == category).toList();
    return ScaffoldIfNeeded(
      standalone: widget.standalone,
      child: Material(
        color: const Color(0xFFFFFBF5),
        child: LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 850;
          final columns = c.maxWidth > 1100
              ? 4
              : c.maxWidth > 700
                  ? 3
                  : 2;
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(
                child: Padding(
              padding:
                  EdgeInsets.fromLTRB(wide ? 32 : 16, 22, wide ? 32 : 16, 8),
              child: Container(
                padding: EdgeInsets.all(wide ? 28 : 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF321B13), Color(0xFF71351C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFB23F),
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text('EGG MACHA • MADE FRESH',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 1))),
                      const SizedBox(height: 12),
                      Text('WHAT ARE YOU\nCRAVING TODAY?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: wide ? 34 : 28,
                              height: 1.05,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      const Text('Fresh • Flavourful • Affordable',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 15)),
                      const SizedBox(height: 14),
                      const Row(children: [
                        Icon(Icons.local_fire_department,
                            color: Color(0xFFFFB23F), size: 19),
                        SizedBox(width: 6),
                        Text('Your favourites, cooked to order',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))
                      ]),
                    ]),
              ),
            )),
            SliverToBoxAdapter(
                child: Padding(
              padding:
                  EdgeInsets.fromLTRB(wide ? 32 : 16, 18, wide ? 32 : 16, 10),
              child: const Text('EXPLORE THE MENU',
                  style: TextStyle(
                      color: Color(0xFF321B13),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5)),
            )),
            SliverToBoxAdapter(
                child: SizedBox(
                    height: 48,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 9),
                      itemBuilder: (_, i) => ChoiceChip(
                        label: Text(categories[i]),
                        selected: category == categories[i],
                        showCheckmark: false,
                        selectedColor: const Color(0xFFFFB23F),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            color: category == categories[i]
                                ? const Color(0xFFFFB23F)
                                : const Color(0xFFE9DCCF)),
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF321B13)),
                        onSelected: (_) =>
                            setState(() => category = categories[i]),
                      ),
                    ))),
            SliverPadding(
                padding:
                    EdgeInsets.fromLTRB(wide ? 32 : 16, 18, wide ? 32 : 16, 30),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (context, i) => FoodCard(item: data[i]),
                      childCount: data.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: c.maxWidth > 700 ? .78 : .62),
                )),
          ]);
        }),
      ),
    );
  }
}

class ScaffoldIfNeeded extends StatelessWidget {
  final bool standalone;
  final Widget child;
  const ScaffoldIfNeeded(
      {super.key, required this.standalone, required this.child});
  @override
  Widget build(BuildContext context) {
    if (!standalone) return child;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        foregroundColor: const Color(0xFF321B13),
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back to home',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Brand(),
      ),
      body: child,
    );
  }
}
