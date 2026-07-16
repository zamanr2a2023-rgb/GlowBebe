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
  final _items = [
    _CartItem('Luminous Bakuchiol Serum', 48, 1, AppAssets.productBakuchiol),
    _CartItem('Velvet Rose Blush', 32, 2, AppAssets.productExtra1),
    _CartItem('Dew Drop Essence', 56, 1, AppAssets.productExtra2),
  ];

  double get _subtotal =>
      _items.fold(0, (sum, i) => sum + i.price * i.qty);
  double get _shipping => _subtotal >= 100 ? 0 : 8;
  double get _total => _subtotal + _shipping;
  double get _discountProgress => (_subtotal / 100).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Your Bag'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePeach.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _subtotal >= 100
                            ? 'You unlocked free shipping!'
                            : 'Spend \$${(100 - _subtotal).toStringAsFixed(0)} more for free shipping',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: _discountProgress,
                          minHeight: 8,
                          backgroundColor: Colors.white,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(_items.length, (i) {
                  final item = _items[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlowSoftCard(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item.image,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${item.price}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _QtyBtn(
                                      icon: Icons.remove,
                                      onTap: () {
                                        setState(() {
                                          if (item.qty > 1) {
                                            item.qty--;
                                          }
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        '${item.qty}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    _QtyBtn(
                                      icon: Icons.add,
                                      onTap: () =>
                                          setState(() => item.qty++),
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
                }),
                const SizedBox(height: 8),
                const GlowSerifTitle('Order Summary', size: 20),
                const SizedBox(height: 12),
                GlowSoftCard(
                  child: Column(
                    children: [
                      _SummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(0)}'),
                      _SummaryRow(
                        'Shipping',
                        _shipping == 0 ? 'FREE' : '\$${_shipping.toStringAsFixed(0)}',
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        'Total',
                        '\$${_total.toStringAsFixed(0)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: GlowPrimaryButton(
                label: 'Proceed to Checkout',
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.checkout),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem {
  _CartItem(this.name, this.price, this.qty, this.image);
  final String name;
  final double price;
  int qty;
  final String image;
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
