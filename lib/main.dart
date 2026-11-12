import 'package:flutter/material.dart';

import 'models/product.dart';
import 'pages/cart.dart';
import 'pages/checkout.dart';
import 'pages/home.dart';
import 'pages/notifications.dart';
import 'pages/product.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/shop.dart';
import 'state/cart_store.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await CartStore.load();
  runApp(OrganicHeritageApp(store: store));
}

class OrganicHeritageApp extends StatefulWidget {
  const OrganicHeritageApp({super.key, this.store});

  final CartStore? store;

  @override
  State<OrganicHeritageApp> createState() => _OrganicHeritageAppState();
}

class _OrganicHeritageAppState extends State<OrganicHeritageApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final CartStore _store;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? CartStore();
  }

  void _openProduct(Product product) {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => ProductPage(
          product: product,
          store: _store,
          onSearch: _openSearch,
          onCart: () {
            _navigatorKey.currentState!.pop();
            setState(() => _selectedTab = 2);
          },
        ),
      ),
    );
  }

  void _openSearch() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => SearchPage(
          store: _store,
          onOpenProduct: _openProduct,
          onNotifications: _openNotifications,
          onCart: () {
            _navigatorKey.currentState!.pop();
            setState(() => _selectedTab = 2);
          },
          onNavigate: (index) {
            _navigatorKey.currentState!.pop();
            setState(() => _selectedTab = index);
          },
        ),
      ),
    );
  }

  void _openNotifications() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationsPage(
          onBack: () => _navigatorKey.currentState!.pop(),
          onSearch: _openSearch,
          onCart: () {
            _navigatorKey.currentState!.pop();
            setState(() => _selectedTab = 2);
          },
          onShop: () {
            _navigatorKey.currentState!.pop();
            setState(() => _selectedTab = 1);
          },
        ),
      ),
    );
  }

  void _openCheckout() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => CheckoutPage(
          store: _store,
          onSearch: _openSearch,
          onCart: () {
            _navigatorKey.currentState!.pop();
            setState(() => _selectedTab = 2);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organic Heritage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: _navigatorKey,
      home: Scaffold(
        backgroundColor: AppColors.canvas,
        body: IndexedStack(
          index: _selectedTab,
          children: [
            HomePage(
              store: _store,
              onOpenProduct: _openProduct,
              onSearch: _openSearch,
              onNotifications: _openNotifications,
              onShop: () => setState(() => _selectedTab = 1),
              onCart: () => setState(() => _selectedTab = 2),
              onProfile: () => setState(() => _selectedTab = 3),
            ),
            ShopPage(
              store: _store,
              onOpenProduct: _openProduct,
              onSearch: _openSearch,
              onNotifications: _openNotifications,
              onCart: () => setState(() => _selectedTab = 2),
            ),
            CartPage(
              store: _store,
              onSearch: _openSearch,
              onNotifications: _openNotifications,
              onShop: () => setState(() => _selectedTab = 1),
              onCheckout: _openCheckout,
            ),
            ProfilePage(
              store: _store,
              onSearch: _openSearch,
              onNotifications: _openNotifications,
              onShop: () => setState(() => _selectedTab = 1),
              onCart: () => setState(() => _selectedTab = 2),
            ),
          ],
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: _store,
          builder: (context, _) => StoreBottomNavigation(
            selectedIndex: _selectedTab,
            cartCount: _store.itemCount,
            onSelected: (index) => setState(() => _selectedTab = index),
          ),
        ),
      ),
    );
  }
}
