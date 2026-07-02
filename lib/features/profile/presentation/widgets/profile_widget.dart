import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/auth/bloc/auth_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderSubtle, width: 1)
              ),
              child: const Icon(Icons.person, size: 48, color: Colors.white54)
            ),
            Positioned(
              bottom: -6,
              right: -6,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2)
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white)
                )
              )
            )
          ]
        ),
        const Gap(AppSpacing.md),
        const Text(
          'Alex Johnson',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textCharcoal
          )
        ),
        const Gap(AppSpacing.sm),
        const Text(
          'admin@gmail.com',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textMuted
          )
        )
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 1.2
      )
    );
  }
}

class MenuCard extends StatelessWidget {
  final List<MenuItem> items;
  const MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [kAmbientShadow]
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;

          return Column(
            children: [
              item,
              if (idx < items.length - 1)
                const Divider(
                  height: 1,
                  indent: 52,
                  endIndent: 0,
                )
            ]
          );
        }).toList()
      )
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MenuItem({required this.icon, required this.title, this.subtitle, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(18),
                  borderRadius: BorderRadius.circular(AppRadius.md)
                ),
                child: Icon(icon, size: 18, color: AppColors.secondary),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textCharcoal
                      )
                    ),
                    if (subtitle != null) ... [
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textMuted
                        ),
                      )
                    ]
                  ],
                )
              ),
              trailing ?? (onTap != null
                ? const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted)
                : const SizedBox.shrink()
              )
            ],
          )
        )
      )
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.booked.withAlpha(60))
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<AuthBloc>().add(const AuthLogoutEvent());
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 18, color: AppColors.booked),
                const Gap(AppSpacing.sm),
                Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.booked
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}