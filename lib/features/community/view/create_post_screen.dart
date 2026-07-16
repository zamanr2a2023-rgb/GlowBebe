import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _selectedTags = <String>{'Skincare'};
  static const _tags = ['Skincare', 'Makeup', 'Routine', 'Review', 'Tips'];

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'New Post',
        actions: [
          TextButton(
            onPressed: () {
              Navigator.maybePop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post published')),
              );
            },
            child: Text(
              'Publish',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upload cover image',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GlowField(
            label: 'Title',
            controller: _title,
            hint: 'Give your story a headline',
          ),
          const SizedBox(height: 16),
          Text(
            'STORY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _body,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Share your glow ritual, review, or tip…',
              filled: true,
              fillColor: AppColors.surface,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          Text(
            'TAGS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((t) {
              final selected = _selectedTags.contains(t);
              return GlowChip(
                label: t,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedTags.remove(t);
                    } else {
                      _selectedTags.add(t);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          GlowPrimaryButton(
            label: 'Publish Post',
            onPressed: () {
              Navigator.maybePop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post published')),
              );
            },
          ),
        ],
      ),
    );
  }
}
