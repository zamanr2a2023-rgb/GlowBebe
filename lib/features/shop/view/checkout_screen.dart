import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _shippingMethod = 0;
  bool _saveCard = true;
  final _card = TextEditingController();
  final _expiry = TextEditingController();
  final _cvc = TextEditingController();
  final _coupon = TextEditingController();

  @override
  void dispose() {
    _card.dispose();
    _expiry.dispose();
    _cvc.dispose();
    _coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'GLOSS & GOSSAMER', brandStyle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                _CheckoutCard(
                  step: '1',
                  title: 'Shipping Address',
                  trailing: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Edit',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alexandria Sterling',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1242 Silk Road, Suite 402',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Los Angeles, CA 90210, USA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '+1 (310) 555-0192',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _CheckoutCard(
                  step: '2',
                  title: 'Shipping Method',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44, top: 4),
                    child: Column(
                      children: [
                        _ShippingOption(
                          title: 'Standard Shipping',
                          subtitle: '3-5 Business Days',
                          price: 'FREE',
                          selected: _shippingMethod == 0,
                          onTap: () => setState(() => _shippingMethod = 0),
                        ),
                        const SizedBox(height: 8),
                        _ShippingOption(
                          title: 'Express Delivery',
                          subtitle: 'Next Day Guarantee',
                          price: '\$18',
                          selected: _shippingMethod == 1,
                          onTap: () => setState(() => _shippingMethod = 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _CheckoutCard(
                  step: '3',
                  title: 'Payment Method',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CARD NUMBER',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.7,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _card,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            letterSpacing: 1.6,
                          ),
                          decoration: _fieldDecoration(
                            '0000 0000 0000',
                            suffix: const Icon(
                              Icons.credit_card,
                              size: 18,
                              color: Color(0xFF807570),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPIRY DATE',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.7,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _expiry,
                                    decoration: _fieldDecoration('MM / YY'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVC',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.7,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _cvc,
                                    obscureText: true,
                                    decoration: _fieldDecoration('***'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _saveCard,
                                onChanged: (v) =>
                                    setState(() => _saveCard = v ?? false),
                                activeColor: AppColors.primary,
                                side: const BorderSide(
                                  color: Color(0xFFD2C4BE),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Save this card for faster checkout next time',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD2C4BE)),
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
                      const SizedBox(height: 20),
                      _MiniItem(
                        title: 'Bio-Identical Silk Serum',
                        meta: '30ml | Qty: 1',
                        price: '\$84',
                        image: AppAssets.productBakuchiol,
                      ),
                      const SizedBox(height: 10),
                      _MiniItem(
                        title: 'Moonlight Barrier Balm',
                        meta: '50ml | Qty: 1',
                        price: '\$72',
                        image: AppAssets.productExtra2,
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFD2C4BE)),
                      const SizedBox(height: 16),
                      Text(
                        'COUPON CODE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.7,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _coupon,
                              decoration: _fieldDecoration('Enter code'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: GoogleFonts.plusJakartaSans(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _Line('Subtotal', '\$156.00'),
                      const SizedBox(height: 8),
                      const _Line('Shipping', 'FREE', highlight: true),
                      const SizedBox(height: 8),
                      const _Line('Tax', '\$12.48'),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFD2C4BE)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$168.48',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            RouteNames.orderStatus,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.lock_outline, size: 16),
                          label: Text(
                            'PLACE ORDER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Payments are encrypted and secure',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.6,
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
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        color: const Color(0xFF6B7280),
      ),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF807570)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF807570)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}

class _CheckoutCard extends StatelessWidget {
  const _CheckoutCard({
    required this.step,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String step;
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2C4BE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.surfacePeach,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  step,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppColors.textWarm,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ShippingOption extends StatelessWidget {
  const _ShippingOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD2C4BE)),
        ),
        child: Row(
          children: [
            Container(
              width: selected ? 22 : 20,
              height: selected ? 22 : 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFF807570),
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniItem extends StatelessWidget {
  const _MiniItem({
    required this.title,
    required this.meta,
    required this.price,
    required this.image,
  });

  final String title;
  final String meta;
  final String price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: const Color(0xFFE5E2E1),
            child: Image.asset(image, width: 64, height: 80, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                meta,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
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
            color: highlight ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
