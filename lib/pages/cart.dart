import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.store,
    required this.onSearch,
    required this.onNotifications,
    required this.onShop,
    required this.onCheckout,
  });

  final CartStore store;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onShop;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final subtotal = store.subtotal;
          final discount = subtotal >= 600 ? 82 : 0;
          final shipping = subtotal == 0 || subtotal >= 499 ? 0 : 50;
          const packaging = 20;
          final total = subtotal + packaging + shipping - discount;
          return Column(
            children: [
              StoreHeader(
                subtitle: 'Cart',
                cartCount: store.itemCount,
                onSearch: onSearch,
                onNotifications: onNotifications,
                onCart: () {},
              ),
              Expanded(
                child: store.productsInCart.isEmpty
                    ? _emptyCart(context)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                        children: [
                          _intro(store.itemCount),
                          const SizedBox(height: 12),
                          _shippingTracker(subtotal),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(
                                child: SectionHeading(
                                  title: 'Basket Provisions',
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  for (final product
                                      in List<Product>.from(store.productsInCart)) {
                                    store.remove(product);
                                  }
                                },
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 14),
                                label: const Text('Clear'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.muted,
                                  textStyle: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          for (final product in store.productsInCart)
                            _cartItem(context, product),
                          const SizedBox(height: 12),
                          _packagingChoice(),
                          const SizedBox(height: 12),
                          _couponCard(discount),
                          const SizedBox(height: 12),
                          _priceSummary(
                            subtotal: subtotal,
                            discount: discount,
                            shipping: shipping,
                            total: total,
                          ),
                        ],
                      ),
              ),
              if (store.itemCount > 0)
                _checkoutBar(context, total)
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _intro(int itemCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MINDFUL LIVING',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 8,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Your Sacred Basket',
                style: TextStyle(
                  color: AppColors.forestDark,
                  fontFamily: 'serif',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.sand,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '🌾  $itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _shippingTracker(int subtotal) {
    final amountToFreeShipping = (499 - subtotal).clamp(0, 499);
    final progress = (subtotal / 499).clamp(0.0, 1.0).toDouble();
    return InfoCard(
      color: const Color(0xFFF4F0E7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.sand,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_shipping_outlined,
                color: AppColors.forest),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Sacred Delivery Milestone',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontFamily: 'serif',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      subtotal >= 499 ? 'Achieved' : '80% Achieved',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtotal >= 499
                      ? 'Your basket qualifies for free sacred shipping.'
                      : 'Add ₹$amountToFreeShipping more for Free Sacred Shipping & an ancient Herbal Sample Pouch!',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 9,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.line,
                    color: AppColors.forest,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Current: ₹$subtotal',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.card_giftcard_rounded,
                        size: 12, color: AppColors.gold),
                    const SizedBox(width: 3),
                    const Text(
                      'Goal: ₹499',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(BuildContext context, Product product) {
    final count = store.quantityFor(product);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDark.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ProductArtwork(
                product: product,
                height: 82,
                iconSize: 34,
                compact: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.forest,
                          fontFamily: 'serif',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => store.remove(product),
                      tooltip: 'Remove ${product.name}',
                      icon: const Icon(Icons.delete_outline_rounded, size: 17),
                      color: AppColors.muted,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${product.unit} • ${product.badge}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      formatRupees(product.price),
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    _QuantityControl(
                      quantity: count,
                      onDecrease: () => store.removeOne(product),
                      onIncrease: () => store.add(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _packagingChoice() {
    return InfoCard(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.eco_outlined, size: 17, color: AppColors.forest),
              SizedBox(width: 8),
              Text(
                'Eco-Conscious Packaging',
                style: TextStyle(
                  color: AppColors.forest,
                  fontFamily: 'serif',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose how your sacred staples arrive at your doorstep.',
            style: TextStyle(color: AppColors.muted, fontSize: 9),
          ),
          const SizedBox(height: 10),
          _packagingOption(
            selected: true,
            title: 'Eco-friendly Cotton Pouch & Box',
            subtitle: 'Reusable raw organic calico pouch wrapped in biodegradable compostable packaging.',
            price: '+₹20',
          ),
          const SizedBox(height: 7),
          _packagingOption(
            selected: false,
            title: 'Standard Recycled Minimal Packaging',
            subtitle: 'Post-consumer recycled kraft cartons with water-activated paper tape.',
            price: 'Free',
          ),
        ],
      ),
    );
  }

  Widget _packagingOption({
    required bool selected,
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF2F7F1) : AppColors.canvas,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColors.paleGreen : AppColors.line,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.circle_outlined,
            color: selected ? AppColors.forest : AppColors.muted,
            size: 14,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 8,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            price,
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _couponCard(int discount) {
    return InfoCard(
      color: const Color(0xFFF4F0E7),
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.sand,
            child: Icon(Icons.sell_outlined, size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HERITAGE10  ·  Applied',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Heritage Inaugural 10% Blessing Discount',
                  style: TextStyle(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          Text(
            discount > 0 ? '-₹$discount' : 'Apply',
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceSummary({
    required int subtotal,
    required int discount,
    required int shipping,
    required int total,
  }) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Price Summary',
            style: TextStyle(
              color: AppColors.forest,
              fontFamily: 'serif',
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _priceRow('Items Subtotal (${store.itemCount} provisions)', subtotal),
          const SizedBox(height: 9),
          _priceRow('Heritage Promo Discount', -discount,
              icon: Icons.verified_outlined),
          const SizedBox(height: 9),
          _priceRow('Sustainable Packaging', 20,
              icon: Icons.eco_outlined),
          const SizedBox(height: 9),
          _priceRow(
            'Sacred Standard Delivery',
            shipping,
            subtitle: shipping == 0 ? 'Free over ₹499 unlocked!' : null,
            trailing: shipping == 0 ? '₹50 FREE' : null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Payable',
                      style: TextStyle(
                        color: AppColors.forest,
                        fontFamily: 'serif',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Inclusive of all local GST',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
              Text(
                formatRupees(total),
                style: const TextStyle(
                  color: AppColors.forest,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    int amount, {
    IconData? icon,
    String? subtitle,
    String? trailing,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: AppColors.green),
          const SizedBox(width: 5),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: AppColors.text, fontSize: 10)),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              trailing,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        Text(
          amount < 0 ? '-₹${amount.abs()}' : '₹$amount',
          style: const TextStyle(
            color: AppColors.forest,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _checkoutBar(BuildContext context, int total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GRAND TOTAL',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 8,
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formatRupees(total),
                style: const TextStyle(
                  color: AppColors.forest,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: PrimaryButton(
              label: 'Proceed to Sacred Checkout',
              icon: Icons.arrow_forward_rounded,
              onPressed: onCheckout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.sand,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_basket_outlined,
                  color: AppColors.forest, size: 38),
            ),
            const SizedBox(height: 18),
            const Text(
              'Your basket is waiting',
              style: TextStyle(
                color: AppColors.forest,
                fontFamily: 'serif',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Explore wholesome staples and thoughtful botanical care.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                label: 'Explore the harvest',
                onPressed: onShop,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove_rounded, size: 13),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            color: AppColors.forest,
          ),
          SizedBox(
            width: 18,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.forest,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrease,
            icon: const Icon(Icons.add_rounded, size: 13),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            color: AppColors.forest,
          ),
        ],
      ),
    );
  }
}
