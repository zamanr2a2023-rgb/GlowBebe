import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_assets.dart';

class LookItem {
  const LookItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String id;
  final String title;
  final String subtitle;
  final String image;
}

class ProductItem {
  const ProductItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.price,
    this.oldPrice,
    this.matchPercent,
    this.discountLabel,
  });

  final String id;
  final String name;
  final String subtitle;
  final String image;
  final String price;
  final String? oldPrice;
  final String? matchPercent;
  final String? discountLabel;
}

class ShadeItem {
  const ShadeItem({
    required this.id,
    required this.name,
    required this.color,
  });

  final String id;
  final String name;
  final Color color;
}

class AdviceCard {
  const AdviceCard({
    required this.title,
    required this.body,
    required this.icon,
    this.linkLabel,
  });

  final String title;
  final String body;
  final IconData icon;
  final String? linkLabel;
}

class TryOnMockData {
  TryOnMockData._();

  static const List<LookItem> featuredLooks = [
    LookItem(
      id: 'natural',
      title: 'Natural Glow',
      subtitle: 'Clean, dewy, everyday finish.',
      image: AppAssets.lookNatural,
    ),
    LookItem(
      id: 'soft_glam',
      title: 'Soft Glam',
      subtitle: 'Polished look with neutral tones.',
      image: AppAssets.lookSoftGlam,
    ),
    LookItem(
      id: 'office',
      title: 'Office Look',
      subtitle: 'Professional and sophisticated matte.',
      image: AppAssets.lookOffice,
    ),
    LookItem(
      id: 'party',
      title: 'Party Look',
      subtitle: 'Bolder eyes and high-shine finishes.',
      image: AppAssets.lookParty,
    ),
  ];

  static const List<ProductItem> recommendedProducts = [
    ProductItem(
      id: 'bakuchiol',
      name: 'Bakuchiol Infusion',
      subtitle: 'Plant-based Retinol Alternative',
      image: AppAssets.productBakuchiol,
      price: '\$67.20',
      oldPrice: '\$84.00',
      matchPercent: '98% Match',
      discountLabel: '20% OFF',
    ),
    ProductItem(
      id: 'ceramide',
      name: 'Ceramide Complex',
      subtitle: 'Intense Barrier Repair',
      image: AppAssets.productExtra2,
      price: '\$54.00',
      matchPercent: '94% Match',
    ),
    ProductItem(
      id: 'niacinamide',
      name: 'Niacinamide Glow',
      subtitle: 'Pore Minimizing Essence',
      image: AppAssets.productExtra3,
      price: '\$42.00',
      matchPercent: '91% Match',
    ),
  ];

  static const List<ShadeItem> lipShades = [
    ShadeItem(id: 'rosewood', name: 'ROSEWOOD', color: Color(0xFF805443)),
    ShadeItem(id: 'nude_pink', name: 'NUDE PINK', color: Color(0xFFD4A395)),
    ShadeItem(id: 'coral_kiss', name: 'CORAL KISS', color: Color(0xFFE38C6D)),
    ShadeItem(id: 'berry', name: 'BERRY SPLASH', color: Color(0xFF8B3A4A)),
    ShadeItem(id: 'mauve', name: 'MATTE MAUVE', color: Color(0xFF7A5C61)),
  ];

  static const List<String> categories = [
    'LIP',
    'BLUSH',
    'EYE',
    'FOUNDATION',
  ];

  static const List<String> presets = [
    'Natural',
    'Soft Glam',
    'Office',
    'Party',
    'Editorial',
  ];

  static const List<ProductItem> shopProducts = [
    ProductItem(
      id: 'serum',
      name: 'Illuminating Serum',
      subtitle: 'Radiance booster',
      image: AppAssets.productExtra1,
      price: '\$58',
      matchPercent: '96% Match',
      discountLabel: '-24% OFF',
    ),
    ProductItem(
      id: 'cream',
      name: 'Barrier Repair Cream',
      subtitle: 'Deep hydration',
      image: AppAssets.productExtra2,
      price: '\$46',
      matchPercent: '93% Match',
    ),
    ProductItem(
      id: 'cleanser',
      name: 'Gentle Foam Cleanser',
      subtitle: 'Soft cleanse',
      image: AppAssets.productExtra3,
      price: '\$32',
      matchPercent: '90% Match',
    ),
    ProductItem(
      id: 'bakuchiol',
      name: 'Bakuchiol Infusion',
      subtitle: 'Plant-based Retinol Alternative',
      image: AppAssets.productBakuchiol,
      price: '\$67.20',
      oldPrice: '\$84.00',
      matchPercent: '98% Match',
      discountLabel: '20% OFF',
    ),
  ];

  static const List<Color> coolWinterSwatches = [
    Color(0xFF2C3E6B),
    Color(0xFF6B2D5C),
    Color(0xFF1A1A2E),
    Color(0xFFC0C0C0),
    Color(0xFF4A0E4E),
    Color(0xFF0D7377),
  ];

  static const List<AdviceCard> placementAdvice = [
    AdviceCard(
      title: 'Blush Placement',
      body:
          'Apply your favorite cream or powder high on the cheekbones, sweeping upwards toward the temples. This vertical movement creates an instant "lift" effect, highlighting your natural bone structure.',
      icon: Icons.face_retouching_natural,
      linkLabel: 'Technique Video',
    ),
    AdviceCard(
      title: 'Eyebrow Shape',
      body:
          'Maintain a soft, natural arch to balance your oval face shape. Focus on filling the outer third of the brow to elongate the eye area, using light, hair-like strokes for an effortless finish.',
      icon: Icons.remove_red_eye_outlined,
      linkLabel: 'Shaping Kit',
    ),
    AdviceCard(
      title: 'Contour & Highlight',
      body:
          'Define the jawline with a subtle shadow just beneath the bone. Pair this with a soft highlight on the center of the chin and bridge of the nose to bring light to the heart of the face.',
      icon: Icons.auto_awesome,
      linkLabel: 'Precision Tools',
    ),
  ];

  static const List<String> clinicalTips = [
    'Prioritize barrier-supporting ceramides before pigment-heavy formulas.',
    'Cool undertones sync best with silver-based highlighters and blue-red lips.',
    'High contrast profiles benefit from defined brows and crisp lip edges.',
  ];
}
