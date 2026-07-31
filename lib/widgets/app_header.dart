import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/utils/landscape_layout.dart';

/// Header dengan tombol back, judul halaman, dan tombol "Beli Paket VIP".
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onVipTap;
  final bool showVipButton;

  const AppHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onVipTap,
    this.showVipButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final compact = LandscapeLayout.isCompactHeight(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: compact ? 4 : 8,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: CircleAvatar(
                radius: compact ? 18 : 22,
                backgroundColor: AppColors.primaryYellow,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: compact ? 20 : 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.heading.copyWith(
                  fontSize: compact ? 20 : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showVipButton) const SizedBox(width: 12),
            if (showVipButton)
              ElevatedButton.icon(
                onPressed: onVipTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 10 : 16,
                    vertical: compact ? 6 : 10,
                  ),
                  textStyle: TextStyle(fontSize: compact ? 12 : 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Icon(Icons.workspace_premium, size: compact ? 16 : 20),
                label: const Text('Beli Paket VIP'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
