import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartStore extends ChangeNotifier {
  final Map<String, int> _quantities = {};
  final Set<String> _favorites = {};

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
    notifyListeners();
  }

  void removeOne(Product product) {
    final count = quantityFor(product);
    if (count <= 1) {
      _quantities.remove(product.id);
    } else {
      _quantities[product.id] = count - 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    _quantities.remove(product.id);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (!_favorites.add(product.id)) {
      _favorites.remove(product.id);
    }
    notifyListeners();
  }

  void clear() {
    _quantities.clear();
    notifyListeners();
  }
}
