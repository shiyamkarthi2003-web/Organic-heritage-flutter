import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    super.key,
    required this.store,
    required this.onOpenProduct,
    required this.onSearch,
    required this.onNotifications,
    required this.onCart,
  });

  final CartStore store;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onCart;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _category = 'All items';
  String _filter = 'Bestselling';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) => Column(
          children: [
            StoreHeader(
              subtitle: 'Shop',
              cartCount: widget.store.itemCount,
              onSearch: widget.onSearch,
              onNotifications: widget.onNotifications,
              onCart: widget.onCart,
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(bottom: 92),
                    children: [
                      _qualityRibbon(),
                      _categorySelector(),
                      _filterSelector(),
                      _harvestRibbon(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _productSections(),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.forest,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.forest.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _showFilters(context),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 1,
                              height: 18,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                              onTap: () => _showSort(context),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.swap_vert_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _filter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _productSections() {
    final grains = productCatalog
        .where((product) => product.category == 'Grains')
        .toList();
    final cosmetics = productCatalog
        .where(
          (product) =>
              product.category == 'Cosmetics' ||
              product.category == 'Hair Care',
        )
        .toList();
    final hygiene = productCatalog
        .where((product) => product.category == 'Hygiene')
        .toList();

    final sections = switch (_category) {
      'Grains' => [('Organic Heritage Grains', grains, false)],
      'Cosmetics' => [('Organic Heritage Cosmetics', cosmetics, false)],
      'Hair Care' => [
        (
          'Herbal Hair Care',
          productCatalog
              .where((product) => product.category == 'Hair Care')
              .toList(),
          false,
        ),
      ],
      'Hygiene' => [('Eco Hygiene Care', hygiene, true)],
      _ => [
        ('Organic Heritage Grains', grains, false),
        ('Organic Heritage Cosmetics', cosmetics, false),
        ('Eco Hygiene Care', hygiene, true),
      ],
    };

    return [
      for (final (title, products, fullWidth) in sections) ...[
        if (products.isNotEmpty) ...[
          SectionHeading(
            title: title,
            subtitle: title == 'Organic Heritage Grains'
                ? 'Authentic heritage varieties · Traditional grains preserved through generations'
                : title == 'Organic Heritage Cosmetics'
                ? 'Herbal traditions and modern care · Safe, effective, and naturally nourishing'
                : '${products.length} plant-based product',
          ),
          const SizedBox(height: 12),
          if (fullWidth)
            ...products.map(_productCard)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) => _productCard(products[index]),
            ),
          if (title != 'Eco Hygiene Care') const SizedBox(height: 18),
        ],
      ],
    ];
  }

  Widget _productCard(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ProductCard(
        product: product,
        isFavorite: widget.store.isFavorite(product),
        onTap: () => widget.onOpenProduct(product),
        onFavorite: () => widget.store.toggleFavorite(product),
        onAdd: () {
          widget.store.add(product);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('${product.name} added to your basket'),
                duration: const Duration(seconds: 2),
              ),
            );
        },
      ),
    );
  }

  Widget _qualityRibbon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EEE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_outlined,
                size: 15,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '100% PURE & CHEMICAL-FREE',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.forestDark,
                      fontSize: 12,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '0 Preservatives · 0 Harsh Chemicals',
                    style: TextStyle(color: AppColors.text, fontSize: 9),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E1B7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PURE PROVENANCE',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categorySelector() {
    const categories = ['All Items', 'Grains', 'Cosmetics'];
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEE8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          for (final label in categories)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(
                  () => _category = label == 'All Items' ? 'All items' : label,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        _category ==
                            (label == 'All Items' ? 'All items' : label)
                        ? AppColors.forest
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color:
                          _category ==
                              (label == 'All Items' ? 'All items' : label)
                          ? Colors.white
                          : AppColors.text,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterSelector() {
    const filters = [
      'All',
      'Heritage Rice',
      'Soup & Booster Mixes',
      'Hair & Skin Care',
      'Zero Preservatives',
    ];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final label = filters[index];
          return Center(
            child: ChoiceChip(
              selected: index == 0,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (index > 0) ...[
                    const Icon(
                      Icons.eco_outlined,
                      size: 11,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(label),
                ],
              ),
              onSelected: (_) {},
              showCheckmark: false,
              labelStyle: TextStyle(
                color: index == 0 ? Colors.white : AppColors.text,
                fontSize: 9,
              ),
              visualDensity: VisualDensity.compact,
              backgroundColor: const Color(0xFFF0EEE8),
              selectedColor: AppColors.forest,
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  Widget _harvestRibbon() {
    final displayedCount = productCatalog.where((product) {
      return switch (_category) {
        'All items' => true,
        'Cosmetics' =>
          product.category == 'Cosmetics' || product.category == 'Hair Care',
        _ => product.category == _category,
      };
    }).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'DISPLAYING $displayedCount ARTISANAL OFFERINGS',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 8,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.circle, size: 6, color: AppColors.gold),
          const SizedBox(width: 5),
          const Text(
            'Zero Preservatives',
            style: TextStyle(color: AppColors.text, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilters(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.canvas,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(title: 'Refine your selection'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in [
                    'All items',
                    'Grains',
                    'Cosmetics',
                    'Hair Care',
                    'Hygiene',
                  ])
                    Pill(
                      label: category,
                      selected: category == _category,
                      onTap: () => Navigator.pop(context, category),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _category = selected);
    }
  }

  Future<void> _showSort(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.canvas,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final sort in [
              'Bestselling',
              'Price: Low to High',
              'Top Rated',
            ])
              ListTile(
                title: Text(sort),
                trailing: sort == _filter
                    ? const Icon(Icons.check_rounded, color: AppColors.forest)
                    : null,
                onTap: () => Navigator.pop(context, sort),
              ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _filter = selected);
    }
  }
}
