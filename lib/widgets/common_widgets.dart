import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

class StoreHeader extends StatelessWidget {
  const StoreHeader({
    super.key,
    required this.subtitle,
    required this.cartCount,
    required this.onSearch,
    required this.onNotifications,
    required this.onCart,
    this.onProfile,
    this.showSearch = true,
    this.showNotifications = true,
    this.showCart = true,
    this.showProfile = false,
  });

  final String subtitle;
  final int cartCount;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onCart;
  final VoidCallback? onProfile;
  final bool showSearch;
  final bool showNotifications;
  final bool showCart;
  final bool showProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(bottom: BorderSide(color: AppColors.line, width: 0.6)),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/organic_heritage_logo.png.png',
            width: 38,
            height: 38,
            fit: BoxFit.contain,
            semanticLabel: 'Organic Heritage logo',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Organic Heritage',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.forestDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
                Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 8,
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (showSearch)
            _HeaderAction(
              icon: Icons.search_rounded,
              label: 'Search',
              onPressed: onSearch,
            ),
          if (showNotifications)
            _HeaderAction(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              onPressed: onNotifications,
              dot: true,
            ),
          if (showCart)
            _HeaderAction(
              icon: Icons.shopping_bag_outlined,
              label: 'Basket',
              onPressed: onCart,
              count: cartCount,
            ),
          if (showProfile && onProfile != null)
            _HeaderAction(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              onPressed: onProfile!,
              filled: true,
            ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.count,
    this.dot = false,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final int? count;
  final bool dot;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            tooltip: label,
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 19,
              color: filled ? Colors.white : AppColors.text,
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            style: filled
                ? IconButton.styleFrom(
                    backgroundColor: AppColors.forestDark,
                    foregroundColor: Colors.white,
                  )
                : null,
          ),
          if (dot)
            const Positioned(
              top: 10,
              right: 8,
              child: CircleAvatar(radius: 3, backgroundColor: AppColors.gold),
            ),
          if (count != null && count! > 0)
            Positioned(
              top: 5,
              right: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: const BoxDecoration(
                  color: AppColors.forest,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BackHeader extends StatelessWidget {
  const BackHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.onSearch,
    this.onCart,
    this.cartCount = 0,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onSearch;
  final VoidCallback? onCart;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(bottom: BorderSide(color: AppColors.line, width: 0.6)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back',
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.forestDark,
                    fontFamily: 'serif',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'ORGANIC HERITAGE',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 8,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          if (onSearch != null)
            IconButton(
              tooltip: 'Search',
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded, size: 20),
            ),
          if (onCart != null)
            IconButton(
              tooltip: 'Basket',
              onPressed: onCart,
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_bag_outlined, size: 19),
              ),
            ),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailing,
    this.subtitle,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.forestDark,
                  fontSize: 19,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif',
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTrailing,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.green,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              trailing!,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({
    super.key,
    required this.product,
    this.height = 156,
    this.iconSize = 58,
    this.compact = false,
  });

  final Product product;
  final double height;
  final double iconSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: product.imageAsset == null
            ? null
            : const Color(0xFFE7D8BF),
        gradient: product.imageAsset == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: product.colors,
              )
            : null,
      ),
      child: product.imageAsset != null
          ? Image.asset(product.imageAsset!, fit: BoxFit.contain)
          : Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -24,
                  top: -32,
                  child: Icon(
                    Icons.eco_rounded,
                    size: height * 0.95,
                    color: Colors.white.withValues(alpha: 0.13),
                  ),
                ),
                Icon(
                  product.icon,
                  size: iconSize,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
                Positioned(
                  left: compact ? 7 : 12,
                  top: compact ? 7 : 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 7 : 9,
                      vertical: compact ? 4 : 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.canvas.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.forest,
                        fontSize: compact ? 8 : 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (!compact)
                  Positioned(
                    bottom: 10,
                    left: 12,
                    right: 12,
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    required this.onAdd,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onAdd;

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
                ProductArtwork(product: product, height: 132, compact: true),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Material(
                    color: AppColors.white.withValues(alpha: 0.94),
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: onFavorite,
                      tooltip: isFavorite
                          ? 'Remove from wishlist'
                          : 'Add to wishlist',
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.red.shade700
                            : AppColors.forest,
                        size: 17,
                      ),
                      padding: const EdgeInsets.all(7),
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.reviews > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.gold,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating} (${product.reviews})',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    )
                  else
                    const Text(
                      'New arrival',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.forestDark,
                      fontFamily: 'serif',
                      fontSize: 14,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.description} • ${product.unit}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${product.price}',
                              style: const TextStyle(
                                color: AppColors.forestDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (product.oldPrice != null)
                              Text(
                                '₹${product.oldPrice}',
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 9,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: FilledButton.icon(
                          onPressed: onAdd,
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('Add'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.forest,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            textStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            minimumSize: Size.zero,
                          ),
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
    );
  }
}

class StoreBottomNavigation extends StatelessWidget {
  const StoreBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.cartCount,
    required this.onSelected,
  });

  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.storefront_outlined, Icons.storefront_rounded, 'Shop'),
    (Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, 'Cart'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 62,
        decoration: const BoxDecoration(
          color: AppColors.canvas,
          border: Border(top: BorderSide(color: AppColors.line, width: 0.7)),
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final selected = selectedIndex == index;
            return Expanded(
              child: InkWell(
                onTap: () => onSelected(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Badge(
                      isLabelVisible: index == 2 && cartCount > 0,
                      label: Text('$cartCount'),
                      child: Icon(
                        selected ? item.$2 : item.$1,
                        size: 19,
                        color: selected ? AppColors.forest : AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.$3,
                      style: TextStyle(
                        color: selected ? AppColors.forest : AppColors.muted,
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.forest : AppColors.white,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.forest : AppColors.line,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 13,
                  color: selected ? Colors.white : AppColors.green,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.text,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 17),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

String formatRupees(int amount) => '₹${amount.toString()}';
