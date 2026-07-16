import 'package:flutter/material.dart';
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
  bool _addressOpen = true;
  int _shippingMethod = 0;
  final _card = TextEditingController(text: '4242 4242 4242 4242');
  final _expiry = TextEditingController(text: '08/28');
  final _cvv = TextEditingController(text: '123');
  final _name = TextEditingController(text: 'Elena Rossi');

  @override
  void dispose() {
    _card.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Checkout'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                GlowSoftCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            setState(() => _addressOpen = !_addressOpen),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Shipping Address',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Icon(
                                _addressOpen
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_addressOpen)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Elena Rossi\n214 Bloom Lane, Apt 4B\nSan Francisco, CA 94110\nUnited States',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const GlowSerifTitle('Shipping Method', size: 20),
                const SizedBox(height: 12),
                GlowSoftCard(
                  child: Column(
                    children: [
                      _MethodTile(
                        title: 'Standard',
                        subtitle: '3–5 business days · Free',
                        selected: _shippingMethod == 0,
                        onTap: () => setState(() => _shippingMethod = 0),
                      ),
                      const Divider(height: 20),
                      _MethodTile(
                        title: 'Express',
                        subtitle: '1–2 business days · \$12',
                        selected: _shippingMethod == 1,
                        onTap: () => setState(() => _shippingMethod = 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const GlowSerifTitle('Payment', size: 20),
                const SizedBox(height: 12),
                GlowField(label: 'Card Number', controller: _card),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: GlowField(label: 'Expiry', controller: _expiry),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlowField(label: 'CVV', controller: _cvv),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GlowField(label: 'Name on Card', controller: _name),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: GlowPrimaryButton(
                label: 'PAY NOW · \$136',
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.orderStatus),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
