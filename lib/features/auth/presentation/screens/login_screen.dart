import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/auth/bloc/auth_bloc.dart';
import 'package:roomsync/features/auth/presentation/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Navigate to home — router handles this via BLoC listener in AppRouter
        }
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.booked, size: 18),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textCharcoal,
                          ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.bookedSurface,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: const BorderSide(color: AppColors.booked, width: 1),
              ),
            ),
          );
          context.read<AuthBloc>().add(const AuthClearErrorEvent());
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Gap(AppSpacing.xxl),
                          _buildHeader(context),
                          const Gap(AppSpacing.xxl),
                          _buildForm(context, isLoading),
                          const Gap(AppSpacing.lg),
                          _buildLoginButton(context, isLoading),
                          const Gap(AppSpacing.md),
                          _buildForgotPassword(context, isLoading),
                          const Spacer(),
                          _buildFooter(context),
                          const Gap(AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo / Brand mark
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceGray,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.primary.withAlpha(77)),
          ),
          child: const Icon(
            Icons.meeting_room_outlined,
            color: AppColors.primary,
            size: 26,
          ),
        ),
        const Gap(AppSpacing.lg),
        Text(
          'Selamat datang',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const Gap(AppSpacing.xs),
        Text(
          'Masuk ke akun RoomSync Anda untuk\nmelanjutkan.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return Column(
      children: [
        AppTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          label: 'Email',
          hint: 'nama@perusahaan.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
          prefixIcon: const Icon(Icons.mail_outline, size: 20),
          onSubmitted: (_) => _passwordFocus.requestFocus(),
          onChanged: (_) {
            if (context.read<AuthBloc>().state.status == AuthStatus.error) {
              context.read<AuthBloc>().add(const AuthClearErrorEvent());
            }
          },
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
        ),
        const Gap(AppSpacing.md),
        AppTextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          label: 'Password',
          isPassword: true,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
          prefixIcon: const Icon(Icons.lock_outline, size: 20),
          onSubmitted: (_) => _submit(),
          onChanged: (_) {
            if (context.read<AuthBloc>().state.status == AuthStatus.error) {
              context.read<AuthBloc>().add(const AuthClearErrorEvent());
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            if (value.length < 8) {
              return 'Password minimal 8 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.textCharcoal),
              ),
            )
          : const Text('Masuk'),
    );
  }

  Widget _buildForgotPassword(BuildContext context, bool isLoading) {
    return Center(
      child: TextButton(
        onPressed: isLoading
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur reset password segera hadir')),
                );
              },
        child: const Text('Lupa password?'),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      'RoomSync v1.0.0 • PT. Organisasi Anda',
      style: Theme.of(context).textTheme.labelSmall,
      textAlign: TextAlign.center,
    );
  }
}