import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class CartStore extends ChangeNotifier {
  CartStore() : _preferences = null;

  CartStore._(this._preferences);

  static const _storageKey = 'organic_heritage_store_v1';

  final SharedPreferences? _preferences;
  final Map<String, int> _quantities = {};
  final Set<String> _favorites = {};
  Future<void> _pendingWrite = Future<void>.value();

  static Future<CartStore> load() async {
    final preferences = await SharedPreferences.getInstance();
    final store = CartStore._(preferences);
    store._restore(preferences.getString(_storageKey));
    return store;
  }

  int get itemCount => _quantities.values.fold(0, (total, count) => total + count);

  int get subtotal {
    return productCatalog.fold(
      0,
      (total, product) => total + product.price * quantityFor(product),
    );
  }

  int quantityFor(Product product) => _quantities[product.id] ?? 0;

  bool isFavorite(Product product) => _favorites.contains(product.id);

  List<Product> get productsInCart {
    return productCatalog.where((product) => quantityFor(product) > 0).toList();
  }

  void add(Product product) {
    _quantities.update(product.id, (count) => count + 1, ifAbsent: () => 1);
    _persist();
    notifyListeners();
  }

  void removeOne(Product product) {
    final count = quantityFor(product);
    if (count <= 1) {
      _quantities.remove(product.id);
    } else {
      _quantities[product.id] = count - 1;
    }
    _persist();
    notifyListeners();
  }

  void remove(Product product) {
    _quantities.remove(product.id);
    _persist();
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (!_favorites.add(product.id)) {
      _favorites.remove(product.id);
    }
    _persist();
    notifyListeners();
  }

  void clear() {
    _quantities.clear();
    _persist();
    notifyListeners();
  }

  Future<void> flush() => _pendingWrite;

  void _restore(String? savedState) {
    if (savedState == null) return;

    final decoded = jsonDecode(savedState);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Saved shop data has an invalid format.');
    }

    final productIds = productCatalog.map((product) => product.id).toSet();
    final quantities = decoded['quantities'];
    if (quantities is! Map<String, dynamic>) {
      throw const FormatException('Saved basket data has an invalid format.');
    }
    for (final entry in quantities.entries) {
      final quantity = entry.value;
      if (quantity is! int || quantity < 1) {
        throw const FormatException('Saved basket quantity is invalid.');
      }
      if (productIds.contains(entry.key)) {
        _quantities[entry.key] = quantity;
      }
    }

    final favorites = decoded['favorites'];
    if (favorites is! List<dynamic>) {
      throw const FormatException('Saved wishlist data has an invalid format.');
    }
    for (final id in favorites) {
      if (id is! String) {
        throw const FormatException('Saved wishlist entry is invalid.');
      }
      if (productIds.contains(id)) _favorites.add(id);
    }
  }

  void _persist() {
    final preferences = _preferences;
    if (preferences == null) return;

    final snapshot = jsonEncode({
      'quantities': _quantities,
      'favorites': _favorites.toList()..sort(),
    });
    _pendingWrite = _pendingWrite.then((_) async {
      final saved = await preferences.setString(_storageKey, snapshot);
      if (!saved) throw StateError('Could not save basket and wishlist data.');
    });
  }
}
