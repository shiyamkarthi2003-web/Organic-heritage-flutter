import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.store,
    required this.onOpenProduct,
    required this.onSearch,
    required this.onNotifications,
    required this.onShop,
    required this.onCart,
    required this.onProfile,
  });

  final CartStore store;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onShop;
  final VoidCallback onCart;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: store,
            builder: (context, _) => StoreHeader(
              subtitle: 'Home',
              cartCount: store.itemCount,
              onSearch: onSearch,
              onNotifications: onNotifications,
              onCart: onCart,
              onProfile: onProfile,
              showCart: false,
              showProfile: true,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Deliver to: Chennai 600078',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.paleGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '●  Farm Fresh Today',
                          style: TextStyle(
                            color: AppColors.forest,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: InkWell(
                    onTap: onSearch,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.forestDark.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 17,
                            color: AppColors.muted,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Search rice, millets, herbal care...',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.tune_rounded,
                            size: 16,
                            color: AppColors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _hero(context),
                _categories(),
                _collections(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: InfoCard(
                    color: const Color(0xFFF3EEE4),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          size: 22,
                          color: AppColors.gold,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '“Healthy living begins with pure choices.”',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.forestDark,
                            fontFamily: 'serif',
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Organic Heritage was created to revive traditional goodness in modern lifestyles. Whether it’s the food that nourishes or the botanicals on your skin, true purity restores balance.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text.withValues(alpha: 0.8),
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '—  OUR SACRED PLEDGE  —',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 9,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'UNCOMPROMISED STANDARD',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const SectionHeading(title: 'Why Organic Heritage?'),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.75,
                        children: const [
                          _ValueCard(
                            icon: Icons.verified_user_outlined,
                            title: 'Pure & Authentic',
                            body: 'Carefully sourced ingredients with minimal processing.',
                          ),
                          _ValueCard(
                            icon: Icons.lightbulb_outline_rounded,
                            title: 'Traditional Wisdom',
                            body: 'Products inspired by generations of natural living.',
                          ),
                          _ValueCard(
                            icon: Icons.eco_outlined,
                            title: 'Sustainable Approach',
                            body: 'Supporting farmers, nature, and responsible production.',
                          ),
                          _ValueCard(
                            icon: Icons.workspace_premium_outlined,
                            title: 'Quality Assured',
                            body: 'Every product crafted with care and consistency.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🌿 100% PURE & CHEMICAL-FREE',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 9,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'ROOTED IN NATURE · CRAFTED FOR EVERYDAY LIVING',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: 9,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Pure Organic Nutrition\n& Botanical Care',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              height: 1.12,
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'From wholesome grains to natural self-care, we bring you products that are pure, authentic, and crafted with care.',
            style: TextStyle(
              color: Color(0xFFE4E2DD),
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              FilledButton(
                onPressed: onShop,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.sand,
                  foregroundColor: AppColors.forestDark,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  minimumSize: const Size(0, 38),
                ),
                child: const Text(
                  'Shop Collection',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Free shipping > ₹499',
                style: TextStyle(color: AppColors.gold, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x337FA385), height: 1),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _HeroBenefit('100% NATURAL'),
              _HeroBenefit('20+ BOTANICALS'),
              _HeroBenefit('0 HARSH CHEMICALS'),
              _HeroBenefit('17+ HERITAGE PRODUCTS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionHeading(
              title: 'Featured Categories',
              trailing: 'See all',
              onTrailing: onShop,
            ),
          ),
          const SizedBox(height: 9),
          _categoryRow('GRAINS:', [
            ('Heritage Rice', Icons.grain_rounded),
            ('Flour', Icons.grain_rounded),
            ('Soup & Booster', Icons.soup_kitchen_rounded),
          ]),
          const SizedBox(height: 5),
          _categoryRow('COSMETICS:', [
            ('Lip Care', Icons.water_drop_outlined),
            ('Skin Care', Icons.spa_outlined),
            ('Hair Care', Icons.brush_rounded),
          ]),
        ],
      ),
    );
  }

  Widget _categoryRow(String heading, List<(String, IconData)> categories) {
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                heading,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 8,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 7),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Center(
                  child: Pill(
                    label: category.$1,
                    icon: category.$2,
                    selected: index == 0 && heading == 'GRAINS:',
                    onTap: onShop,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _collections(BuildContext context) {
    final grainProduct = productCatalog.firstWhere(
      (product) => product.category == 'Grains',
    );
    final careProduct = productCatalog.firstWhere(
      (product) => product.category == 'Cosmetics',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TWO WORLDS, ONE HERITAGE',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const SectionHeading(title: 'Sacred Provenance'),
          const SizedBox(height: 12),
          _CollectionCard(
            product: grainProduct,
            title: 'Organic Heritage Grains',
            subtitle:
                'Traditional Rice Varieties · Millets & Pulses · Chemical-Free',
            footnote: 'Farm-To-Table Traditional Quality',
            action: 'Explore Grains',
            onTap: () => onOpenProduct(grainProduct),
          ),
          const SizedBox(height: 10),
          _CollectionCard(
            product: careProduct,
            title: 'Organic Heritage Cosmetics',
            subtitle: 'Herbal Ingredients · Gentle on Skin · Free from Harsh Chemicals',
            footnote: 'Inspired by Traditional Care',
            action: 'Explore Care',
            onTap: () => onOpenProduct(careProduct),
          ),
        ],
      ),
    );
  }
}

class _HeroBenefit extends StatelessWidget {
  const _HeroBenefit(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135,
      child: Row(
        children: [
          const CircleAvatar(radius: 3, backgroundColor: AppColors.gold),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.product,
    required this.title,
    required this.subtitle,
    required this.footnote,
    required this.action,
    required this.onTap,
  });

  final Product product;
  final String title;
  final String subtitle;
  final String footnote;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductArtwork(product: product, height: 174, iconSize: 74),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Single-estate provenance',
                      style: TextStyle(
                        color: AppColors.forest,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'serif',
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            footnote,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$action  ›',
                    style: const TextStyle(
                      color: AppColors.forest,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
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
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.green),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
