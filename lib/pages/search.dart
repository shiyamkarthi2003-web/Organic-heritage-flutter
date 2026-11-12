import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.store,
    required this.onOpenProduct,
    required this.onNotifications,
    required this.onCart,
    required this.onNavigate,
  });

  final CartStore store;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onNotifications;
  final VoidCallback onCart;
  final ValueChanged<int> onNavigate;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  final List<String> _recentSearches = [
    'Heritage Rice',
    'Beetroot Lip Balm',
    'Health Malts',
    'Herbal Hair Oil',
    'Soup & Booster Mix',
    'Face Glow Oil',
  ];

  List<Product> get _results {
    final normalized = _query.trim().toLowerCase();
    if (normalized.isEmpty) return productCatalog.take(4).toList();
    return productCatalog
        .where(
          (product) =>
              product.name.toLowerCase().contains(normalized) ||
              product.description.toLowerCase().contains(normalized) ||
              product.category.toLowerCase().contains(normalized),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Column(
          children: [
            AnimatedBuilder(
              animation: widget.store,
              builder: (context, _) => StoreHeader(
                subtitle: 'Search',
                cartCount: widget.store.itemCount,
                onSearch: () =>
                    _searchController.selection = TextSelection.collapsed(
                      offset: _searchController.text.length,
                    ),
                onNotifications: widget.onNotifications,
                onCart: widget.onCart,
                showSearch: false,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.forestDark.withValues(
                              alpha: 0.045,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: AppColors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) =>
                                  setState(() => _query = value),
                              textInputAction: TextInputAction.search,
                              decoration: const InputDecoration(
                                hintText: 'Search grains, cold-pressed oils, herbal care...',
                                hintStyle: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: const TextStyle(
                                color: AppColors.forest,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_query.isNotEmpty) {
                                _searchController.clear();
                                setState(() => _query = '');
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            tooltip: _query.isEmpty
                                ? 'Voice search'
                                : 'Clear search',
                            icon: Icon(
                              _query.isEmpty
                                  ? Icons.mic_none_rounded
                                  : Icons.close_rounded,
                              color: AppColors.gold,
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 30,
                              height: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          color: AppColors.green,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Text(
                            'RECENT INQUIRIES',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 8,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(_recentSearches.clear),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_recentSearches.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final search in _recentSearches)
                            InputChip(
                              label: Text(search),
                              onPressed: () => _setQuery(search),
                              onDeleted: () => setState(
                                () => _recentSearches.remove(search),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 12),
                              labelStyle: const TextStyle(
                                color: AppColors.text,
                                fontSize: 9,
                              ),
                              backgroundColor: AppColors.white,
                              side: const BorderSide(color: AppColors.line),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: Row(
                      children: [
                        const Expanded(
                          child: SectionHeading(
                            title: 'Trending Herbal Searches',
                          ),
                        ),
                        TextButton(
                          onPressed: () => _setQuery('Hair Care'),
                          child: const Text(
                            'Apothecary & Farm',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InfoCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _trendRow(
                            1,
                            'Heritage Rice & Millets',
                            'Traditional Rice Varieties, unpolished',
                            'rice',
                          ),
                          _trendRow(
                            2,
                            'Beetroot Lip Balm',
                            'Enriched with natural oil and Vitamin E',
                            'lip balm',
                          ),
                          _trendRow(
                            3,
                            'Herbal Hair Oil (Moringa & Rosemary)',
                            'Cold pressed coconut oil & rosemary EO',
                            'hair oil',
                          ),
                          _trendRow(
                            4,
                            'Health Malts & Booster Mixes',
                            'Pure traditional nutritional drink mix',
                            'malt',
                          ),
                          _trendRow(
                            5,
                            'Karisalankani Baby Kajal',
                            'Pure Bhringaraj soot, castor oil & pure ghee',
                            'kajal',
                            last: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: SectionHeading(
                      title: _query.isEmpty
                          ? 'Explore by Category'
                          : 'Matching Categories',
                      trailing: '6 Collections',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.28,
                      children: [
                        _categoryTile(
                          Icons.grain_rounded,
                          'FARM DIRECT',
                          'Heritage Rice',
                          'Traditional varieties, chemical-free & nutrient rich',
                          'rice',
                        ),
                        _categoryTile(
                          Icons.soup_kitchen_outlined,
                          'VITALITY',
                          'Soup & Booster Mixes',
                          'Traditional nutrition & immunity vitality blends',
                          'malt',
                        ),
                        _categoryTile(
                          Icons.spa_outlined,
                          'WHOLESOME',
                          'Health Malts & Cookies',
                          'Wholesome everyday nourishment for all ages',
                          'malt',
                        ),
                        _categoryTile(
                          Icons.water_drop_outlined,
                          'PURE BOTANICALS',
                          'Lip Care & Skin Care',
                          'Beetroot balm, face glow oil & herbal face care',
                          'skin care',
                        ),
                        _categoryTile(
                          Icons.eco_outlined,
                          'SIDDHA CARE',
                          'Hair Care',
                          'Moringa hair oil, herbal wash & scalp masks',
                          'hair care',
                        ),
                        _categoryTile(
                          Icons.health_and_safety_outlined,
                          'CLEAN & SAFE',
                          'Hygiene',
                          '100% plant-based sanitary care',
                          'hygiene',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: SectionHeading(
                      title: _query.isEmpty
                          ? 'Popular Products from the Heritage'
                          : 'Search Results',
                      trailing: _query.isEmpty
                          ? 'View All'
                          : '${_results.length} found',
                    ),
                  ),
                  if (_results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No products found. Try searching for grains, herbs or care.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    )
                  else
                    ..._results.map(_productResult),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: StoreBottomNavigation(
          selectedIndex: -1,
          cartCount: widget.store.itemCount,
          onSelected: widget.onNavigate,
        ),
      ),
    );
  }

  void _setQuery(String value) {
    _searchController.text = value;
    _searchController.selection = TextSelection.collapsed(offset: value.length);
    setState(() => _query = value);
  }

  Widget _trendRow(
    int number,
    String title,
    String subtitle,
    String query, {
    bool last = false,
  }) {
    return InkWell(
      onTap: () => _setQuery(query),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 11,
              backgroundColor: const Color(0xFFF5E8C9),
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.forest,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.muted, fontSize: 8),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.north_east_rounded,
              color: AppColors.muted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryTile(
    IconData icon,
    String label,
    String title,
    String body,
    String query,
  ) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _setQuery(query),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.forest,
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.forest,
                  fontFamily: 'serif',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 8,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productResult(Product product) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) => InkWell(
        onTap: () => widget.onOpenProduct(product),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 74,
                height: 74,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: ProductArtwork(
                    product: product,
                    height: 74,
                    iconSize: 30,
                    compact: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 7,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontFamily: 'serif',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${product.description} • ${product.unit}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 8,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          formatRupees(product.price),
                          style: const TextStyle(
                            color: AppColors.forest,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => widget.store.add(product),
                          tooltip: 'Add to basket',
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: AppColors.forest,
                            size: 21,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
