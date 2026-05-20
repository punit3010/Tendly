import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/tendly_logo.dart';

/// Screen 1 of 5 — Sign In
/// Handles: email/password, Google SSO, Apple SSO, navigate to sign up.
/// Auth logic is stubbed — wire Supabase in [_handleEmailSignIn] etc.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Auth handlers (wire Supabase here) ────────────────────────────────────

  Future<void> _handleEmailSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // TODO: replace with Supabase auth
      // await Supabase.instance.client.auth.signInWithPassword(
      //   email: _emailCtrl.text.trim(),
      //   password: _passwordCtrl.text,
      // );
      await Future.delayed(const Duration(milliseconds: 800)); // temp stub
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError('Sign in failed. Please check your details.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      // TODO: wire Google + Supabase OAuth
      // await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError('Google sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      // TODO: wire Apple + Supabase OAuth
      // await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.apple);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError('Apple sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:          Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor:  Colors.redAccent,
        behavior:         SnackBarBehavior.floating,
        shape:            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),

                // ── Logo ──────────────────────────────────────────────────
                const TendlyLogo(iconSize: 72, showTagline: true),

                const SizedBox(height: 48),

                // ── Email field ───────────────────────────────────────────
                _FieldLabel(text: 'Email'),
                const SizedBox(height: 6),
                TextFormField(
                  controller:   _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize:   15,
                    color:      TendlyColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.mail_outline_rounded,
                      color: TendlyColors.primaryLight, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your email';
                    if (!v.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Password field ────────────────────────────────────────
                _FieldLabel(text: 'Password'),
                const SizedBox(height: 6),
                TextFormField(
                  controller:      _passwordCtrl,
                  obscureText:     _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleEmailSignIn(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize:   15,
                    color:      TendlyColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText:   '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: TendlyColors.primaryLight, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                        color: TendlyColors.primaryLight,
                        size:  20,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your password';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: navigate to forgot password screen
                    },
                    child: const Text('Forgot password?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize:   13,
                        color:      TendlyColors.primary,
                      )),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Primary sign in button ────────────────────────────────
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailSignIn,
                  child: _isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Sign in'),
                ),

                const SizedBox(height: 24),

                // ── Divider ───────────────────────────────────────────────
                const _Divider(),

                const SizedBox(height: 20),

                // ── Google sign in ────────────────────────────────────────
                OutlinedButton(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GoogleIcon(),
                      const SizedBox(width: 10),
                      const Text('Continue with Google'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Apple sign in ─────────────────────────────────────────
                OutlinedButton(
                  onPressed: _isLoading ? null : _handleAppleSignIn,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apple, size: 22,
                        color: TendlyColors.textPrimary),
                      SizedBox(width: 10),
                      Text('Continue with Apple'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Sign up link ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize:   13,
                        color:      TendlyColors.textSecondary,
                      )),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text('Sign up free',
                        style: TextStyle(
                          fontFamily:  'Poppins',
                          fontSize:    13,
                          fontWeight:  FontWeight.w600,
                          color:       TendlyColors.primary,
                        )),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Small private widgets ──────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
        style: const TextStyle(
          fontFamily:  'Poppins',
          fontSize:    13,
          fontWeight:  FontWeight.w500,
          color:       TendlyColors.textPrimary,
        )),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: TendlyColors.border, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('or',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize:   12,
              color:      TendlyColors.textSecondary,
            )),
        ),
        Expanded(child: Divider(color: TendlyColors.border, thickness: 1)),
      ],
    );
  }
}

/// Google 'G' logo drawn in Flutter — no image asset needed.
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    void arc(double start, double sweep, Color color) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start, sweep, true,
        Paint()..color = color,
      );
    }

    arc(  -0.52, 1.57, const Color(0xFF4285F4)); // blue
    arc(   1.05, 1.57, const Color(0xFF34A853)); // green
    arc(   2.62, 1.05, const Color(0xFFFBBC05)); // yellow
    arc(   3.67, 1.05, const Color(0xFFEA4335)); // red

    // White center to make it a ring
    canvas.drawCircle(c, r * 0.6,
      Paint()..color = Colors.white);

    // Google 'G' bar
    final barPaint = Paint()
      ..color       = const Color(0xFF4285F4)
      ..strokeWidth = r * 0.38
      ..strokeCap   = StrokeCap.round
      ..style       = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(c.dx, c.dy),
      Offset(c.dx + r * 0.75, c.dy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
