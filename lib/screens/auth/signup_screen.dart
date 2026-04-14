import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import '_auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding/interese');
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
                          title: 'Bun venit!',
                          subtitle: 'Creează-ți contul în câteva secunde.',
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        // Prenume
                        TextInputField(
                          label: 'Prenume',
                          hint: 'ex: Maria',
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Completează prenumele'
                              : null,
                        ),

                        const SizedBox(height: BabyMamaSpacing.lg),

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
                          hint: 'Minim 8 caractere',
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Completează parola';
                            if (v.length < 8) return 'Parola trebuie să aibă minim 8 caractere';
                            return null;
                          },
                        ),

                        const SizedBox(height: BabyMamaSpacing.lg),

                        // Confirmă parola
                        TextInputField(
                          label: 'Confirmă parola',
                          hint: 'Repetă parola',
                          controller: _confirmController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Confirmă parola';
                            if (v != _passwordController.text) return 'Parolele nu coincid';
                            return null;
                          },
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl3),

                        PrimaryButton(
                          label: 'Creează cont',
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),

                        const SizedBox(height: BabyMamaSpacing.xl2),

                        SwitchAuthRow(
                          message: 'Ai deja un cont?',
                          actionLabel: 'Intră în cont',
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
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
