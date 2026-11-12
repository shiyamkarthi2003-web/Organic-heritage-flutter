import 'package:flutter/material.dart';

import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.store,
    required this.onSearch,
    required this.onNotifications,
    required this.onShop,
    required this.onCart,
  });

  final CartStore store;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onShop;
  final VoidCallback onCart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) => Column(
          children: [
            StoreHeader(
              subtitle: 'Profile',
              cartCount: store.itemCount,
              onSearch: onSearch,
              onNotifications: onNotifications,
              onCart: onCart,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 18),
                children: [
                  _profileHero(),
                  _quickLinks(context),
                  _footprint(),
                  _preferences(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                    child: OutlinedButton.icon(
                      onPressed: () => _showSignOut(context),
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text('Sign Out of Heritage Profile'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        foregroundColor: Colors.red.shade700,
                        backgroundColor: const Color(0xFFEEECE7),
                        side: BorderSide.none,
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'ORGANIC HERITAGE  ·  VERSION 1.0.0',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 8,
                        letterSpacing: 0.7,
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

  Widget _profileHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFD8B77A), Color(0xFF6D835B)],
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.forest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Lakshmanan S.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.forest,
                              fontFamily: 'serif',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.verified_rounded,
                          color: AppColors.gold,
                          size: 16,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      '♙  Golden Seed Patron · Since 2023',
                      style: TextStyle(
                        color: AppColors.forest,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+91 98402 ••••8',
                      style: TextStyle(color: AppColors.muted, fontSize: 10),
                    ),
                    Text(
                      'lakshmanan@heritage.org',
                      style: TextStyle(color: AppColors.muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F0E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.sand,
                  child: Icon(
                    Icons.spa_rounded,
                    size: 17,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HERITAGE CLUB REWARDS',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 8,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '480 Herbal Roots',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontFamily: 'serif',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(78, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Redeem →', style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.gold,
                size: 13,
              ),
              SizedBox(width: 5),
              Text(
                'Worth ₹240 on your next harvest order',
                style: TextStyle(color: AppColors.text, fontSize: 9),
              ),
              Spacer(),
              Text(
                'Tier 2',
                style: TextStyle(color: AppColors.muted, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Sacred Sanctuary',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 8,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickLink(
                  icon: Icons.inventory_2_outlined,
                  title: 'My Sacred Orders',
                  body: 'Out for dispatch • Mappillai Samba',
                  badge: '1 Active',
                  onTap: onCart,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickLink(
                  icon: Icons.location_on_outlined,
                  title: 'Saved Havens',
                  body: 'KK Nagar & Farmhouse',
                  badge: '2 Places',
                  onTap: () => _showMessage(context, 'Saved addresses'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _QuickLink(
                  icon: Icons.favorite_border_rounded,
                  title: 'Wishlist & Curations',
                  body: 'Wild honey, Kumkumadi oil',
                  onTap: onShop,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickLink(
                  icon: Icons.calendar_month_outlined,
                  title: 'Apothecary Subs',
                  body: 'Cold-pressed sesame & red rice',
                  badge: 'Monthly',
                  onTap: () => _showMessage(context, 'Monthly subscriptions'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footprint() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InfoCard(
        color: const Color(0xFFECEAE4),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.eco_rounded, size: 17, color: AppColors.gold),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Living Organic Footprint',
                    style: TextStyle(
                      color: AppColors.forest,
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'Verified Impact',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: _ImpactTile(
                    icon: Icons.pedal_bike_rounded,
                    metric: '14 kg',
                    caption: 'Chemical-free harvests',
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _ImpactTile(
                    icon: Icons.forest_rounded,
                    metric: '3 Trees',
                    caption: 'Cauvery delta',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            const Row(
              children: [
                Icon(Icons.wb_sunny_outlined, size: 13, color: AppColors.gold),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '~42.8 kg CO₂eq avoided',
                    style: TextStyle(color: AppColors.text, fontSize: 9),
                  ),
                ),
                Text(
                  'Lifetime',
                  style: TextStyle(color: AppColors.muted, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _preferences() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Preferences & Care',
            subtitle: 'Customize your seasonal botanical and diet profile',
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.spa_outlined,
                            color: AppColors.gold,
                            size: 16,
                          ),
                          const SizedBox(width: 7),
                          const Expanded(
                            child: Text(
                              'Dietary Preferences',
                              style: TextStyle(
                                color: AppColors.forest,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          Pill(label: '✓  Gluten-Free', selected: true),
                          Pill(label: '✓  Diabetic Friendly', selected: true),
                          Pill(label: '♡  Vegan'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 14, endIndent: 14),
                Material(
                  color: AppColors.white,
                  child: SwitchListTile(
                    value: true,
                    onChanged: (_) {},
                    activeThumbColor: AppColors.forest,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    title: const Text(
                      'Harvest & Batch Alerts',
                      style: TextStyle(
                        color: AppColors.forest,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: const Text(
                      'Arrival notifications for raw honey & heirloom pulses',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 14, endIndent: 14),
                _settingsRow(
                  Icons.storefront_outlined,
                  'Flagship Apothecary Care',
                  '#333/97, KK Nagar, Chennai • Support Desk',
                ),
                const Divider(height: 1, indent: 14, endIndent: 14),
                _settingsRow(
                  Icons.verified_user_outlined,
                  'Organic Authenticity Pledge',
                  'Traceability protocols & lab certified reports',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsRow(IconData icon, String title, String subtitle) {
    return Material(
      color: AppColors.white,
      child: ListTile(
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        leading: Icon(icon, size: 17, color: AppColors.green),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.forest,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.muted, fontSize: 9),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: AppColors.muted,
        ),
      ),
    );
  }

  Future<void> _showMessage(BuildContext context, String label) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: const Text(
          'This section is ready to connect to your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSignOut(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your saved preferences will be here when you return.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFF0EEE9),
                    child: Icon(icon, color: AppColors.green, size: 16),
                  ),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sand,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: AppColors.forest,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.forest,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 9,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactTile extends StatelessWidget {
  const _ImpactTile({
    required this.icon,
    required this.metric,
    required this.caption,
  });

  final IconData icon;
  final String metric;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.gold),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric,
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
