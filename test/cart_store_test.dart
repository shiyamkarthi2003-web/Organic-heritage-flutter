import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:organic_heritage_flutter/models/product.dart';
import 'package:organic_heritage_flutter/state/cart_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('basket quantities and favorites survive store reload', () async {
    final product = productCatalog.first;
    final store = await CartStore.load();

    store.add(product);
    store.add(product);
    store.toggleFavorite(product);
    await store.flush();

    final restoredStore = await CartStore.load();
    expect(restoredStore.quantityFor(product), 2);
    expect(restoredStore.isFavorite(product), isTrue);
  });

  test('clearing the basket persists without clearing favorites', () async {
    final product = productCatalog.first;
    final store = await CartStore.load();

    store.add(product);
    store.toggleFavorite(product);
    await store.flush();
    store.clear();
    await store.flush();

    final restoredStore = await CartStore.load();
    expect(restoredStore.quantityFor(product), 0);
    expect(restoredStore.isFavorite(product), isTrue);
  });
}
