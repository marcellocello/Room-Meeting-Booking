import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:roomsync/core/theme/app_theme.dart';

class DeviceBlockedScreen extends StatelessWidget {
  const DeviceBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 72,
                height: 72,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.bookedSurface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.booked.withAlpha(100)),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.booked,
                  size: 36,
                ),
              ),
              Text(
                'Perangkat Tidak Aman',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.md),
              Text(
                'RoomSync tidak dapat dijalankan pada perangkat yang '
                'telah di-root atau di-jailbreak.\n\n'
                'Penggunaan perangkat yang dimodifikasi dapat membahayakan '
                'keamanan data organisasi Anda.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.surfaceGray),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.borderSubtle,
                      size: 16,
                    ),
                    const Gap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Hubungi administrator IT Anda jika Anda yakin ini adalah kesalahan.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
