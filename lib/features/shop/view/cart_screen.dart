import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _coupon = TextEditingController(text: 'GLOSS10');
  final _items = [
    _CartItem(
      'Silk Serum',
      'Bio-Repair',
      '30ml · Soft Peach',
      84,
      1,
      AppAssets.productBakuchiol,
    ),
    _CartItem(
      'Barrier Balm',
      'Night Care',
      '50ml · Unscented',
      72,
      1,
      AppAssets.productExtra2,
    ),
  ];

  double get _subtotal => _items.fold(0, (sum, i) => sum + i.price * i.qty);
  double get _discount => 15.6;
  double get _total => _subtotal - _discount;

  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'LUMINA', brandStyle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Row(
                  children: [
                    Text(
                      'Your Bag',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 34 / 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_items.length} ITEMS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.7,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ...List.generate(_items.length, (i) {
                  final item = _items[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _CartCard(
                      item: item,
                      onMinus: () {
                        setState(() {
                          if (item.qty > 1) item.qty--;
                        });
                      },
                      onPlus: () => setState(() => item.qty++),
                      onDelete: () => setState(() => _items.removeAt(i)),
                    ),
                  );
                }),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD2C4BE).withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SummaryRow(
                        'Subtotal',
                        '\$${_subtotal.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 12),
                      const _SummaryRow('Shipping', 'COMPLIMENTARY'),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        'Discount',
                        '-\$${_discount.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFD2C4BE), height: 1),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${_total.toStringAsFixed(2)}',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Coupon Code',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _coupon,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: const Color(0xFF6B7280),
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF807570),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF807570),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Apply',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GlowPrimaryButton(
                        label: 'Proceed to Checkout',
                        height: 56,
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteNames.checkout,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 18,
                            color: AppColors.textPrimary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 18,
                            color: AppColors.textPrimary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: AppColors.textPrimary.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePeach.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfacePeach),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 18,
                        color: AppColors.iconMuted,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complimentary shipping unlocked',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                color: AppColors.textWarm,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your order ships free with carbon-neutral packaging.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                height: 1.4,
                                color: AppColors.textWarm.withValues(alpha: 0.8),
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
          ),
        ],
      ),
    );
  }
}

class _CartItem {
  _CartItem(
    this.name,
    this.category,
    this.variant,
    this.price,
    this.qty,
    this.image,
  );

  final String name;
  final String category;
  final String variant;
  double price;
  int qty;
  final String image;
}

class _CartCard extends StatelessWidget {
  const _CartCard({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onDelete,
  });

  final _CartItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2C4BE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColoredBox(
              color: const Color(0xFFF0EDED),
              child: Image.asset(
                item.image,
                width: 96,
                height: 128,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: 128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.category.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.name,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.variant,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFD2C4BE)),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: onMinus,
                              child: const Icon(
                                Icons.remove,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '${item.qty}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onPlus,
                              child: const Icon(
                                Icons.add,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${item.price.toStringAsFixed(0)}',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isComplimentary = value == 'COMPLIMENTARY';
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            letterSpacing: isComplimentary ? 0.8 : 0,
            color: isComplimentary
                ? AppColors.iconMuted
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
