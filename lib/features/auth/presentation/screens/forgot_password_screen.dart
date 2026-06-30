import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/auth/presentation/widgets/app_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    showAppDialog(
      context,
      icon: Icons.check,
      iconColor: AppColors.available,
      iconBackground: AppColors.availableSurface,
      title: 'Link Sent Successfully',
      message: 'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.',
      primaryLabel: 'Back to Login',
      onPrimaryPressed: () {
        Navigator.of(context).pop();
        context.go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceGray,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildFormState(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        height: MediaQuery.of(context).size.height * .15,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage('assets/images/icon_transparent.png'),
                  fit: BoxFit.contain
                )
              ),
            ),
            Text(
              'RoomSync',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textCharcoal,
                letterSpacing: -0.5
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Gap(AppSpacing.xxl),
          Center(
            child: Text(
              'Forgot password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                letterSpacing: 0.5,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textCharcoal
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                letterSpacing: 0.5,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textMuted
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Email Address',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textCharcoal,
              letterSpacing: 0.5
            ),
          ),
          const Gap(AppSpacing.sm),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            autofocus: false,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textCharcoal,
              fontSize: 14
            ),
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'name@company.com',
              prefixIcon: Icon(Icons.mail_outline, size: 20, color: AppColors.outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email tidak boleh kosong';
              }
              final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Format email tidak valid';
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary
            ),
            child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.onPrimary),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                        letterSpacing: 0.5
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Icon(Icons.arrow_forward, color: AppColors.background, size: 20),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}