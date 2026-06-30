import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:roomsync/core/theme/app_theme.dart';

class AppDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  const AppDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textCharcoal,
                letterSpacing: 0.5
              ),
            ),
            const Gap(AppSpacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: onPrimaryPressed,
              child: Text(
                primaryLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                  letterSpacing: 0.5
                ),
              ),
            ),
            if (secondaryLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
                child: Text(secondaryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> showAppDialog(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required Color iconBackground,
  required String title,
  required String message,
  required String primaryLabel,
  required VoidCallback onPrimaryPressed,
  String? secondaryLabel,
  VoidCallback? onSecondaryPressed,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black.withAlpha(100),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, secondaryAnim, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6 * anim.value,
          sigmaY: 6 * anim.value,
        ),
        child: FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: AppDialog(
              icon: icon,
              iconColor: iconColor,
              iconBackground: iconBackground,
              title: title,
              message: message,
              primaryLabel: primaryLabel,
              onPrimaryPressed: onPrimaryPressed,
              secondaryLabel: secondaryLabel,
              onSecondaryPressed: onSecondaryPressed,
            ),
          ),
        ),
      );
    },
  );
}