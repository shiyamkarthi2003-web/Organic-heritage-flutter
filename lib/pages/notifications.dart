import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
    required this.onBack,
    required this.onShop,
    required this.onSearch,
    required this.onCart,
  });

  final VoidCallback onBack;
  final VoidCallback onShop;
  final VoidCallback onSearch;
  final VoidCallback onCart;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _filter = 'All';
  bool _hasUnread = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Column(
          children: [
            BackHeader(
              title: 'Notifications',
              onBack: widget.onBack,
              onSearch: widget.onSearch,
              onCart: widget.onCart,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: SectionHeading(title: 'Notifications'),
                      ),
                      TextButton.icon(
                        onPressed: () => setState(() => _hasUnread = false),
                        icon: const Icon(
                          Icons.done_all_rounded,
                          color: AppColors.green,
                          size: 14,
                        ),
                        label: const Text('Mark all as read'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.green,
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _filterChip('All', _hasUnread ? '4' : '0'),
                        _filterChip('Orders & Harvest', ''),
                        _filterChip('Seasonal Offers', ''),
                        _filterChip('Apothecary', ''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_filter == 'All' || _filter == 'Orders & Harvest')
                    _notificationCard(
                      icon: Icons.local_shipping_outlined,
                      tag: 'ORDERS & HERITAGE HARVEST',
                      age: '24 mins ago',
                      title: 'Harvest Dispatched: Order #OH-89241',
                      body: 'Your fresh batch of Mappillai Samba Rice and Lip Butter has been packed with love and handed over to our eco-courier.',
                      unread: _hasUnread,
                      footer: _progressFooter(),
                    ),
                  if (_filter == 'All' || _filter == 'Seasonal Offers')
                    _notificationCard(
                      icon: Icons.grain_rounded,
                      tag: 'SEASONAL GRAINS HARVEST',
                      age: 'Yesterday',
                      title: 'Fresh Winter Harvest Alert',
                      body: 'Newly harvested Karuppu Kavuni Black Rice is now in stock directly from Thanjavur regenerative farmers.',
                      unread: _hasUnread,
                      footer: _offerFooter(),
                      iconColor: AppColors.gold,
                      iconBackground: const Color(0xFFF3E1B7),
                    ),
                  if (_filter == 'All' || _filter == 'Orders & Harvest')
                    _notificationCard(
                      icon: Icons.volunteer_activism_outlined,
                      tag: 'REGENERATIVE REWARDS',
                      age: '2 days ago',
                      title: 'Loyalty Roots Credited: 120 Herbal Coins',
                      body: 'Thank you for choosing regenerative organic eating! You earned 120 roots coins with your recent grains and cold-pressed oil refill.',
                      unread: _hasUnread,
                      footer: _coinsFooter(),
                      iconColor: AppColors.forest,
                      iconBackground: AppColors.paleGreen,
                    ),
                  if (_filter == 'All' || _filter == 'Apothecary')
                    _notificationCard(
                      icon: Icons.auto_awesome_outlined,
                      tag: 'APOTHECARY JOURNAL',
                      age: '4 days ago',
                      title: 'Seasonal Herbal Guide: Ancient Monsoon Elixirs',
                      body: 'Discover traditional Kashayam blends to boost winter immunity naturally using native spices, dry ginger, and wild forest tulsi.',
                      unread: false,
                      footer: _journalFooter(),
                      iconColor: AppColors.green,
                      iconBackground: const Color(0xFFE9E6DC),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String count) {
    final selected = _filter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        selected: selected,
        showCheckmark: false,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (count.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(count, style: const TextStyle(fontSize: 9)),
            ],
          ],
        ),
        onSelected: (_) => setState(() => _filter = label),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.text,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        selectedColor: AppColors.forest,
        backgroundColor: const Color(0xFFF0EEE9),
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required String tag,
    required String age,
    required String title,
    required String body,
    required bool unread,
    required Widget footer,
    Color iconColor = AppColors.forest,
    Color iconBackground = const Color(0xFFF1EEE5),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDark.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: iconBackground,
                child: Icon(icon, size: 20, color: iconColor),
              ),
              if (unread)
                const Positioned(
                  right: -1,
                  top: -1,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: AppColors.forest,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 8,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      age,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.forestDark,
                    fontFamily: 'serif',
                    fontSize: 16,
                    height: 1.12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                footer,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressFooter() {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1EA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.eco_outlined, size: 15, color: AppColors.green),
          const SizedBox(width: 6),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zero-Plastic',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Estimated arrival tomorrow',
                  style: TextStyle(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.forest,
              foregroundColor: Colors.white,
              minimumSize: const Size(88, 30),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              textStyle: const TextStyle(fontSize: 9),
            ),
            child: const Text('Track Package  →'),
          ),
        ],
      ),
    );
  }

  Widget _offerFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F0E7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '🌾  Single-Estate Provenance',
            style: TextStyle(
              color: AppColors.forest,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: widget.onShop,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.forest,
              backgroundColor: AppColors.sand,
              side: BorderSide.none,
              minimumSize: const Size(112, 30),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 9),
            ),
            child: const Text('Shop Harvest  →'),
          ),
        ),
      ],
    );
  }

  Widget _coinsFooter() {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF5ECD6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.sand,
            child: Text('CO', style: TextStyle(fontSize: 8)),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Heritage Balance',
                style: TextStyle(color: AppColors.muted, fontSize: 8),
              ),
              Text(
                '840 Roots Coins ≈ ₹420 OFF',
                style: TextStyle(
                  color: AppColors.forest,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _journalFooter() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            '3 min mindful read',
            style: TextStyle(color: AppColors.muted, fontSize: 9),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.menu_book_outlined, size: 12),
          label: const Text('Read Journal'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.forest,
            backgroundColor: const Color(0xFFF4F0E7),
            side: BorderSide.none,
            minimumSize: const Size(100, 30),
            textStyle: const TextStyle(fontSize: 9),
          ),
        ),
      ],
    );
  }
}
