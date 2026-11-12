import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.product,
    required this.store,
    required this.onSearch,
    required this.onCart,
  });

  final Product product;
  final CartStore store;
  final VoidCallback onSearch;
  final VoidCallback onCart;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  bool _nutritionExpanded = true;
  bool _methodExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Column(
          children: [
            AnimatedBuilder(
              animation: widget.store,
              builder: (context, _) => BackHeader(
                title: 'Product Details',
                onBack: () => Navigator.of(context).pop(),
                onSearch: widget.onSearch,
                onCart: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  widget.onCart();
                },
                cartCount: widget.store.itemCount,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  Stack(
                    children: [
                      ProductArtwork(
                        product: product,
                        height: 270,
                        iconSize: 110,
                      ),
                      if (product.imageAsset == null) ...[
                        Positioned(
                          left: 16,
                          top: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _imageBadge(
                                Icons.verified_user_outlined,
                                '100% Biodiversity Farmed',
                              ),
                              const SizedBox(height: 4),
                              _imageBadge(Icons.grain_rounded, 'Zero Polish'),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 14,
                          child: _imageBadge(
                            Icons.verified_rounded,
                            'GI Tag Heritage',
                          ),
                        ),
                      ],
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_imageDot(true)],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (product.reviews > 0) ...[
                              const Icon(
                                Icons.star_rounded,
                                size: 15,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '(${product.reviews} verified apothecary reviews)',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ] else
                              const Expanded(
                                child: Text(
                                  'New arrival',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            IconButton(
                              onPressed: () {},
                              tooltip: 'Share product',
                              icon: const Icon(
                                Icons.share_outlined,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: AppColors.forestDark,
                            fontFamily: 'serif',
                            fontSize: 24,
                            height: 1.12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatRupees(product.price),
                              style: const TextStyle(
                                color: AppColors.forest,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.oldPrice != null)
                              Text(
                                formatRupees(product.oldPrice!),
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            const Spacer(),
                            const Text(
                              'Incl. of all taxes',
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: _quantitySelector(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _accordion(
                      title: 'Nutritional & Medicinal Virtues',
                      icon: Icons.eco_outlined,
                      expanded: _nutritionExpanded,
                      onTap: () => setState(
                        () => _nutritionExpanded = !_nutritionExpanded,
                      ),
                      child: _nutritionDetails(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: _accordion(
                      title: 'Apothecary Culinary Method',
                      icon: Icons.soup_kitchen_outlined,
                      expanded: _methodExpanded,
                      onTap: () =>
                          setState(() => _methodExpanded = !_methodExpanded),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          'Rinse gently and soak for 20 minutes. Cook slowly with 2.5 cups of water until tender. Rest covered for 10 minutes before serving.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: InfoCard(
                      color: const Color(0xFFF6F0DF),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: AppColors.gold,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Laboratory Tested Purity',
                                  style: TextStyle(
                                    color: AppColors.forest,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'NABL Accredited Lab Certified: zero detectable pesticide residues. Every harvest is tested and guaranteed non-GMO indigenous seed lineage.',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 9,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Batch #TN-MS-2026-B4 • Harvested Nov 2025',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: widget.store,
              builder: (context, _) => Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: const BoxDecoration(
                  color: AppColors.canvas,
                  border: Border(top: BorderSide(color: AppColors.line)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => widget.store.toggleFavorite(product),
                      tooltip: 'Wishlist',
                      icon: Icon(
                        widget.store.isFavorite(product)
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.forest,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: PrimaryButton(
                        label:
                            'Add to Sacred Basket · ${formatRupees(product.price * _quantity)}',
                        icon: Icons.shopping_basket_outlined,
                        onPressed: () {
                          for (var index = 0; index < _quantity; index++) {
                            widget.store.add(product);
                          }
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text('Added to your Sacred Basket'),
                              ),
                            );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.canvas.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.forest),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageDot(bool selected) {
    return Container(
      width: selected ? 18 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: selected ? AppColors.forest : AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _quantitySelector() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Quantity:',
            style: TextStyle(color: AppColors.text, fontSize: 11),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                icon: const Icon(Icons.remove, size: 15),
                constraints: const BoxConstraints.tightFor(
                  width: 38,
                  height: 36,
                ),
              ),
              Text(
                '$_quantity',
                style: const TextStyle(
                  color: AppColors.forest,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _quantity++),
                icon: const Icon(Icons.add, size: 15),
                constraints: const BoxConstraints.tightFor(
                  width: 38,
                  height: 36,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accordion({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: [
                  Icon(icon, size: 17, color: AppColors.forest),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontFamily: 'serif',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.green,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) child,
        ],
      ),
    );
  }

  Widget _nutritionDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: _NutritionTile(
                  title: 'Dietary Fiber',
                  value: '4.2g',
                  unit: '/ 100g',
                  body: 'Regulates gut microbiome',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _NutritionTile(
                  title: 'Glycemic Index',
                  value: '51',
                  unit: '(Low)',
                  body: 'Prevents insulin spikes',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in [
            (
              'Boosts Hemoglobin',
              'Abundant bioavailable iron replenishes cellular oxygen carrying capacity.',
            ),
            (
              'Sustained Stamina',
              'Slow-release complex carbohydrates fuel enduring physical resilience.',
            ),
            (
              'Rich in Anthocyanin',
              'Natural red antioxidant pigment shields cellular vitality.',
            ),
          ])
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 13,
                    color: AppColors.gold,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 10,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: '${item.$1}: ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: item.$2),
                        ],
                      ),
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

class _NutritionTile extends StatelessWidget {
  const _NutritionTile({
    required this.title,
    required this.value,
    required this.unit,
    required this.body,
  });

  final String title;
  final String value;
  final String unit;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.muted, fontSize: 8),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 8,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
