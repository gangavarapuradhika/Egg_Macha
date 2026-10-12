import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const brown = Color(0xFF24140D);
  static const deepBrown = Color(0xFF160B07);
  static const orange = Color(0xFFF28C28);
  static const gold = Color(0xFFFFB84D);
  static const cream = Color(0xFFFFF5E8);
  static const paper = Color(0xFFFFFBF5);
  static const green = Color(0xFF5D7A3A);
  static const red = Color(0xFFD94B2B);
  static const muted = Color(0xFF806B60);
}

class MenuItemModel {
  final String name;
  final String description;
  final String image;
  final String category;
  final double price;

  const MenuItemModel({
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
  });
}

const menuItems = <MenuItemModel>[
  MenuItemModel(
      name: 'Masala Omelette',
      description: 'Desi masala, fresh from the tawa',
      image: 'assets/images/omelette.png',
      category: 'Omelettes',
      price: 149),
  MenuItemModel(
      name: 'Cheese Egg Maggi',
      description: 'Buttery noodles with an egg twist',
      image: 'assets/images/maggi.png',
      category: 'Maggi',
      price: 129),
  MenuItemModel(
      name: 'Avocado Egg Toast',
      description: 'Crunchy sourdough. Creamy avocado.',
      image: 'assets/images/avocado_toast.png',
      category: 'Sandwiches',
      price: 179),
  MenuItemModel(
      name: 'Egg Bhurji Pav',
      description: 'Spicy, buttery bhurji with warm pav',
      image: 'assets/images/bhurji_pav.png',
      category: 'Egg Pav',
      price: 159),
  MenuItemModel(
      name: 'Egg Curry + Bagara Rice',
      description: 'Fragrant rice combo with rich egg curry',
      image: 'assets/images/egg_curry_rice.png',
      category: 'Meals',
      price: 219),
  MenuItemModel(
      name: 'Tawa Fried Eggs',
      description: 'Runny yolks, masala and a hot tawa',
      image: 'assets/images/fried_egg.png',
      category: 'Half Boiled',
      price: 99),
  MenuItemModel(
      name: 'Double Cheese Omelette',
      description: 'Extra cheese, extra comfort',
      image: 'assets/images/omelette_alt.png',
      category: 'Omelettes',
      price: 189),
  MenuItemModel(
      name: 'Macha Special Maggi',
      description: 'The house-style noodle bowl',
      image: 'assets/images/maggi_alt.png',
      category: 'Maggi',
      price: 149),
];

class CartController extends ChangeNotifier {
  final Map<MenuItemModel, int> items = <MenuItemModel, int>{};

  void add(MenuItemModel item) {
    items[item] = (items[item] ?? 0) + 1;
    notifyListeners();
  }

  void remove(MenuItemModel item) {
    final current = items[item];
    if (current == null) return;
    if (current <= 1) {
      items.remove(item);
    } else {
      items[item] = current - 1;
    }
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }

  int get count => items.values.fold(0, (sum, value) => sum + value);

  double get total => items.entries.fold(
        0,
        (sum, entry) => sum + entry.key.price * entry.value,
      );
}

final cart = CartController();

/// Snapshot of one menu item and the quantity purchased in an order.
class OrderLine {
  final String name;
  final double unitPrice;
  final int quantity;

  const OrderLine({
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  double get subtotal => unitPrice * quantity;
}

/// Frontend-only order model. Connect this to your backend/database later.
class CustomerOrder {
  final String id;
  final List<OrderLine> lines;
  final double total;
  final DateTime createdAt;
  final String status;
  final String deliveryAddress;

  CustomerOrder({
    required this.id,
    required this.lines,
    required this.total,
    required this.createdAt,
    this.status = 'Order placed',
    this.deliveryAddress = '',
  });
}

class DeliveryAddress {
  final String label;
  final String fullName;
  final String phone;
  final String house;
  final String street;
  final String city;
  final String state;
  final String pinCode;
  final String landmark;

  const DeliveryAddress(
      {required this.label,
      required this.fullName,
      required this.phone,
      required this.house,
      required this.street,
      required this.city,
      required this.state,
      required this.pinCode,
      this.landmark = ''});

  String get formatted =>
      '$house, $street, $city, $state - $pinCode${landmark.trim().isEmpty ? '' : ', Near $landmark'}';
}

class AddressStore extends ChangeNotifier {
  static const _storageKey = 'egg_macha_saved_addresses_v1';
  final List<DeliveryAddress> _addresses = [];
  DeliveryAddress? selected;
  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw) as List<dynamic>;
      _addresses
        ..clear()
        ..addAll(decoded.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return DeliveryAddress(
            label: map['label'] as String? ?? 'Home',
            fullName: map['fullName'] as String? ?? '',
            phone: map['phone'] as String? ?? '',
            house: map['house'] as String? ?? '',
            street: map['street'] as String? ?? '',
            city: map['city'] as String? ?? '',
            state: map['state'] as String? ?? '',
            pinCode: map['pinCode'] as String? ?? '',
            landmark: map['landmark'] as String? ?? '',
          );
        }));
      if (_addresses.isNotEmpty) selected = _addresses.first;
      notifyListeners();
    } catch (error) {
      debugPrint('Could not load saved addresses: $error');
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _addresses
        .map((a) => <String, dynamic>{
              'label': a.label,
              'fullName': a.fullName,
              'phone': a.phone,
              'house': a.house,
              'street': a.street,
              'city': a.city,
              'state': a.state,
              'pinCode': a.pinCode,
              'landmark': a.landmark,
            })
        .toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  void save(DeliveryAddress address) {
    _addresses.add(address);
    selected = address;
    notifyListeners();
    _persist().catchError((Object error) {
      debugPrint('Could not persist saved address: $error');
    });
  }

  void choose(DeliveryAddress address) {
    selected = address;
    notifyListeners();
  }

  void update(DeliveryAddress oldAddress, DeliveryAddress newAddress) {
    final index = _addresses.indexOf(oldAddress);
    if (index >= 0) _addresses[index] = newAddress;
    if (selected == oldAddress) selected = newAddress;
    notifyListeners();
    _persist().catchError((Object error) {
      debugPrint('Could not persist updated address: $error');
    });
  }
}

final addressStore = AddressStore();

class OrderStore extends ChangeNotifier {
  final List<CustomerOrder> _orders = <CustomerOrder>[];

  List<CustomerOrder> get orders => List.unmodifiable(_orders);

  CustomerOrder createFromCart(CartController cart,
      {required String deliveryAddress}) {
    final now = DateTime.now();
    final order = CustomerOrder(
      id: 'EM${now.millisecondsSinceEpoch.toString().substring(5)}',
      lines: cart.items.entries
          .map((entry) => OrderLine(
                name: entry.key.name,
                unitPrice: entry.key.price,
                quantity: entry.value,
              ))
          .toList(),
      total: cart.total,
      createdAt: now,
      deliveryAddress: deliveryAddress,
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}

final orderStore = OrderStore();
