import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultConcernsScreen extends StatefulWidget {
  const ConsultConcernsScreen({super.key});

  @override
  State<ConsultConcernsScreen> createState() => _ConsultConcernsScreenState();
}

class _ConsultConcernsScreenState extends State<ConsultConcernsScreen> {
  final _selected = <String>{'Dark Spots'};

  static const _options = [
    'Acne',
    'Dark Spots',
    'Redness',
    'Dryness',
    'Fine Lines',
    'Large Pores',
    'Dullness',
    'Sensitivity',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GlowAppBar(title: 'Concerns'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                GlowSerifTitle('What should we focus on?', size: 26),
                const SizedBox(height: 8),
                Text(
                  'Select one or more concerns for this consult.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _options.map((o) {
                    final on = _selected.contains(o);
                    return GlowChip(
                      label: o,
                      selected: on,
                      onTap: () => setState(() {
                        if (on) {
                          _selected.remove(o);
                        } else {
                          _selected.add(o);
                        }
                      }),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Anything else you want the coach to know?',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.borderSoft),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.borderSoft),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GlowPrimaryButton(
                label: 'CONTINUE TO CHAT',
                onPressed: _selected.isEmpty
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          RouteNames.consultChat,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
