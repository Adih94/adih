import 'package:flutter/material.dart';
import '../core/constants/app_text_styles.dart';
import '../data/models/lesson_model.dart';

/// Badge di pojok kiri atas card, meniru gaya pita/ribbon pada referensi:
/// bulatan mahkota + label "VIP", dan label kecil "Platinum" di bawahnya
/// kalau tier-nya platinum.
class VipBadge extends StatelessWidget {
  final VipTier tier;

  const VipBadge({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    if (tier == VipTier.none) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF4A2C7A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium,
                  color: Color(0xFFFFD54F), size: 14),
              const SizedBox(width: 3),
              Text('VIP', style: AppTextStyles.badgeText.copyWith(fontSize: 11)),
            ],
          ),
        ),
        if (tier == VipTier.platinum)
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Platinum',
              style: AppTextStyles.badgeText.copyWith(fontSize: 8),
            ),
          ),
      ],
    );
  }
}
