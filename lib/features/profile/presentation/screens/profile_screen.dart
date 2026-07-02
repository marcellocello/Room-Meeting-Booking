import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/profile/presentation/widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.ambientShadow,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textCharcoal,
          )
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          const Gap(AppSpacing.xl),
          ProfileHeader(),
          const Gap(AppSpacing.xl),
          SectionLabel(label: 'ACCOUNT'),
          const Gap(AppSpacing.xs),
          MenuCard(
            items: [
              MenuItem(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Manage your identity and bio',
                onTap: () {},
              ),
              MenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Security and access control',
                onTap: () {},
              )
            ],
          ),
          const Gap(AppSpacing.lg),
          LogoutButton(),
          const Gap(AppSpacing.xxl)
        ],
      )
    );
  }
}