import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final resp = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        final route = resp.user.onboardingCompleted
            ? '/' // TODO: replace with home route once it exists
            : '/onboarding/interese';
        Navigator.pushReplacementNamed(context, route);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eroare de rețea. Încearcă din nou.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: BabyMamaColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  BabyMamaSpacing.xl2,
                  BabyMamaSpacing.lg,
                  BabyMamaSpacing.xl2,
                  0,
                ),
                child: Row(
                  children: [
                    AuthBackButton(onTap: () => Navigator.pop(context)),
                    const Spacer(),
                    Text(
                      'babymama',
                      style: BabyMamaTypography.titleMedium.copyWith(
                        color: BabyMamaColors.neutral300,
                        fontFamily: 'Cormorant Garamond',
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable form ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BabyMamaSpacing.xl2,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: BabyMamaSpacing.xl3),

                        const SectionTitle(
                          title: 'Bun revenit!',
                          subtitle: 'Drag să te revedem printre noi.',
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // Email
                        TextInputField(
                          label: 'Adresă de email',
                          hint: 'ex: maria@gmail.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.mail_outline_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Completează emailul';
                            if (!v.contains('@') || !v.contains('.')) return 'Email invalid';
                            return null;
                          },
                        ),

                        const SizedBox(height: BabyMamaSpacing.lg),

                        // Parolă
                        TextInputField(
                          label: 'Parolă',
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Completează parola' : null,
                        ),

                        const SizedBox(height: BabyMamaSpacing.md),

                        // Ai uitat parola?
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: forgot password flow
                            },
                            child: Text(
                              'Ai uitat parola?',
                              style: BabyMamaTypography.labelMedium.copyWith(
                                color: BabyMamaColors.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: BabyMamaColors.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        PrimaryButton(
                          label: 'Intră în cont',
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl2),

                        SwitchAuthRow(
                          message: 'Nu ai cont încă?',
                          actionLabel: 'Înregistrează-te',
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/signup'),
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
