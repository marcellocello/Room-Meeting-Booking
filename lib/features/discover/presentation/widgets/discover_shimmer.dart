import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:roomsync/core/theme/app_theme.dart';

class _ShimmerBox extends StatelessWidget {
  final Widget child;
  const _ShimmerBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: const Color(0xFFF6F3F5),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

Widget _block({double? width, double height = 14, double radius = 6}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
    )
  );
}

class RoomCardShimmer extends StatelessWidget {
  const RoomCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _block(width: 120, height: 18),
                      const Spacer(),
                      _block(width: 50, height: 14),
                    ]
                  ),
                  const SizedBox(height: 8),
                  _block(width: 160, height: 14),
                  const SizedBox(height: 14),
                  _block(width: double.infinity, height: 40, radius: AppRadius.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}