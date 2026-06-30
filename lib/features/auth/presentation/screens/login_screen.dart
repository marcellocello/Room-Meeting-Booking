import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/core/utils/app_router.dart';
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
          backgroundColor: AppColors.surfaceGray,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeader(context),
                          const Gap(AppSpacing.md),
                          _buildForm(context, isLoading),
                          const Gap(AppSpacing.xxl),
                          _buildFooter(context),
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
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: 82,
      color: Colors.transparent,
      margin: EdgeInsets.only(right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 72,
            height: 72,
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
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return Container(
      width: MediaQuery.of(context).size.width * .85,
      height: MediaQuery.of(context).size.height * .55,
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withAlpha(77)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const Gap(AppSpacing.xs),
            Text(
              'Enter your credentials to access your organization\'s workspace.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Email Address',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textCharcoal,
                letterSpacing: 0.5
              ),
            ),
            const Gap(AppSpacing.sm),
            AppTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: 'Email',
              hint: 'name@company.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              prefixIcon: const Icon(Icons.mail_outline, size: 20, color: AppColors.outline),
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
            const Gap(AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textCharcoal,
                    letterSpacing: 0.5
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          _emailController.clear();
                          _passwordController.clear();
                        });
                        context.push(AppRoutes.forgotPassword);
                      },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      letterSpacing: 0.5
                    ),
                  ),
                )
              ],
            ),
            AppTextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: 'Password',
              isPassword: true,
              hint: '*******',
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.outline),
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
            const Gap(AppSpacing.xl),
            ElevatedButton(
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
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
            )
          ],
        ),
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