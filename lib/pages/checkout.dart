import 'package:flutter/material.dart';

import '../state/cart_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.store,
    required this.onSearch,
    required this.onCart,
  });

  final CartStore store;
  final VoidCallback onSearch;
  final VoidCallback onCart;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _delivery = 'Standard Eco-Delivery';
  String _payment = 'UPI Instant Transfer';
  final TextEditingController _vpaController = TextEditingController();
  bool _isVerified = false;
  bool _manifestExpanded = false;

  int get _total {
    final subtotal = widget.store.subtotal;
    final discount = subtotal >= 600 ? 82 : 0;
    final shipping = subtotal == 0 || subtotal >= 499 ? 0 : 50;
    final express = _delivery == 'Morning Harvest Express' ? 40 : 0;
    return subtotal + 20 + shipping + express - discount;
  }

  @override
  void dispose() {
    _vpaController.dispose();
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
              builder: (context, _) => BackHeader(
                title: 'Checkout',
                onBack: () => Navigator.of(context).pop(),
                onSearch: widget.onSearch,
                onCart: widget.onCart,
                cartCount: widget.store.itemCount,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                children: [
                  _steps(),
                  const SizedBox(height: 14),
                  _dispatchAddress(),
                  const SizedBox(height: 14),
                  _deliveryOptions(),
                  const SizedBox(height: 14),
                  _paymentOptions(),
                  const SizedBox(height: 14),
                  _orderManifest(),
                  const SizedBox(height: 14),
                  _securityNote(),
                ],
              ),
            ),
            _placeOrderBar(),
          ],
        ),
      ),
    );
  }

  Widget _steps() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1EB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          _CheckoutStep(label: '1. Delivery', state: 0),
          Expanded(child: Divider(color: AppColors.forestDark, thickness: 1.5)),
          _CheckoutStep(label: '2. Payment', state: 1),
          Expanded(child: Divider(color: AppColors.line, thickness: 1.5)),
          _CheckoutStep(label: '3. Confirm', state: 2),
        ],
      ),
    );
  }

  Widget _dispatchAddress() {
    return InfoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: AppColors.forest,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Dispatch Sanctuary',
                        style: TextStyle(
                          color: AppColors.forestDark,
                          fontFamily: 'serif',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _badge('DEFAULT'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Lakshmanan S.',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const Text(
            '#333/97, Lakshmanaswamy Salai, KK Nagar,\nChennai — 600078, Tamil Nadu',
            style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 12,
                      color: AppColors.muted,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+91 98765 43210',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
                  'Change Address  ›',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryOptions() {
    return InfoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.eco_outlined, size: 17, color: AppColors.gold),
              SizedBox(width: 5),
              Text(
                'Delivery Rhythm',
                style: TextStyle(
                  color: AppColors.forestDark,
                  fontFamily: 'serif',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _selectionTile(
            groupValue: _delivery,
            value: 'Standard Eco-Delivery',
            title: 'Standard Eco-Delivery',
            subtitle: '2–3 Days • 100% Carbon Neutral Transit in biodegradable hemp sleeves',
            trailing: 'FREE',
            onChanged: (value) => setState(() => _delivery = value),
          ),
          const SizedBox(height: 8),
          _selectionTile(
            groupValue: _delivery,
            value: 'Morning Harvest Express',
            title: 'Morning Harvest Express',
            subtitle: 'Tomorrow before 10 AM • Direct freshly packed lot from Chengalpattu farm',
            trailing: '₹40',
            onChanged: (value) => setState(() => _delivery = value),
          ),
        ],
      ),
    );
  }

  Widget _paymentOptions() {
    return InfoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 17,
                      color: AppColors.forest,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Payment Protocol',
                      style: TextStyle(
                        color: AppColors.forestDark,
                        fontFamily: 'serif',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Step 2 of 3',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RadioGroup<String>(
            groupValue: _payment,
            onChanged: (value) {
              if (value != null) setState(() => _payment = value);
            },
            child: Column(
              children: [
                _paymentTile(
                  value: 'UPI Instant Transfer',
                  title: 'UPI Instant Transfer',
                  subtitle: 'GPay, PhonePe, Paytm, BHIM',
                  trailing: 'UPI ϟ',
                  selectedContent: _upiForm(),
                ),
                const SizedBox(height: 8),
                _paymentTile(
                  value: 'Credit / Debit Card',
                  title: 'Credit / Debit Card',
                  subtitle: 'Visa, Mastercard, RuPay',
                  trailing: '▤',
                ),
                const SizedBox(height: 8),
                _paymentTile(
                  value: 'Net Banking',
                  title: 'Net Banking',
                  subtitle: 'HDFC, SBI, ICICI, Axis & 50+ Banks',
                  trailing: '♙',
                ),
                const SizedBox(height: 8),
                _paymentTile(
                  value: 'Cash on Delivery',
                  title: 'Cash on Delivery',
                  subtitle: 'Pay with cash or UPI QR upon receiving',
                  trailing: '₹',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile({
    required String value,
    required String title,
    required String subtitle,
    required String trailing,
    Widget? selectedContent,
  }) {
    final selected = _payment == value;
    return Material(
      color: selected ? const Color(0xFFF3F1EB) : AppColors.canvas,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => setState(() => _payment = value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: value,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.forest,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    trailing,
                    style: const TextStyle(
                      color: AppColors.forest,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (selected && selectedContent != null) ...[
                const SizedBox(height: 8),
                selectedContent,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _upiForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Virtual Payment Address (VPA):',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _vpaController,
                onChanged: (_) => setState(() => _isVerified = false),
                decoration: InputDecoration(
                  hintText: 'lakshmanan@okaxis',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA8ADA7),
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 7),
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: _vpaController.text.trim().contains('@')
                    ? () => setState(() => _isVerified = true)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.forestDark,
                  disabledBackgroundColor: AppColors.forestDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(_isVerified ? 'Verified' : 'Verify'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _orderManifest() {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _manifestExpanded = !_manifestExpanded),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            leading: const Icon(
              Icons.shopping_bag_outlined,
              size: 18,
              color: AppColors.forest,
            ),
            title: const Text(
              'Order Manifest',
              style: TextStyle(
                color: AppColors.forestDark,
                fontFamily: 'serif',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              '${widget.store.itemCount} items • Mappillai Samba & Botanicals',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatRupees(_total),
                  style: const TextStyle(
                    color: AppColors.forestDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Icon(
                  _manifestExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                ),
              ],
            ),
          ),
          if (_manifestExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                children: [
                  for (final product in widget.store.productsInCart)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.store.quantityFor(product)} × ${product.name}',
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Text(
                            formatRupees(
                              product.price * widget.store.quantityFor(product),
                            ),
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
        ],
      ),
    );
  }

  Widget _securityNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.forest),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              '100% ENCRYPTED 256-BIT SSL CONNECTION',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text(
            'PCI-DSS Verified',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeOrderBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
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
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formatRupees(_total),
                style: const TextStyle(
                  color: AppColors.forestDark,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              label: 'Place Sacred Order  🔒',
              onPressed: _placeOrder,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.canvas,
        icon: const Icon(
          Icons.check_circle_rounded,
          color: AppColors.green,
          size: 42,
        ),
        title: const Text(
          'Your harvest is reserved',
          style: TextStyle(
            color: AppColors.forest,
            fontFamily: 'serif',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'We’ll send order updates to your registered contact. Payment: $_payment.',
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.store.clear();
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Continue shopping'),
          ),
        ],
      ),
    );
  }

  Widget _selectionTile({
    required String groupValue,
    required String value,
    required String title,
    required String subtitle,
    required String trailing,
    required ValueChanged<String> onChanged,
  }) {
    final selected = groupValue == value;
    return Material(
      color: selected ? const Color(0xFFF3F1EB) : AppColors.canvas,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.circle_outlined,
                size: 15,
                color: selected ? AppColors.forest : AppColors.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                trailing,
                style: const TextStyle(
                  color: AppColors.forestDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E1B7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.forestDark,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CheckoutStep extends StatelessWidget {
  const _CheckoutStep({required this.label, required this.state});

  final String label;
  final int state;

  @override
  Widget build(BuildContext context) {
    final active = state == 1;
    final complete = state == 0;
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: complete || active ? AppColors.forestDark : AppColors.line,
              shape: BoxShape.circle,
              border: active
                  ? Border.all(color: AppColors.paleGreen, width: 4)
                  : null,
            ),
            child: Icon(
              complete
                  ? Icons.check_rounded
                  : active
                  ? Icons.payments_outlined
                  : Icons.settings_outlined,
              size: 15,
              color: complete || active ? Colors.white : AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: state == 2 ? AppColors.muted : AppColors.forestDark,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
