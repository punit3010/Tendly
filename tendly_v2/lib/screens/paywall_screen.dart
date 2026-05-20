import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _yearlySelected = true;
  bool _isLoading = false;

  Future<void> _startTrial() async {
    setState(() => _isLoading = true);
    // TODO: wire RevenueCat
    // await Purchases.purchasePackage(package);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Hero ───────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: TendlyColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Column(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: TendlyColors.primaryDark,
                        borderRadius: BorderRadius.circular(18)),
                      child: const Icon(Icons.workspace_premium_outlined,
                        color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 14),
                    const Text('Unlock Tendly Pro',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 22,
                        fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 6),
                    const Text('Everything your child needs, every day',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                        color: TendlyColors.primaryLight)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Features ─────────────────────────────────────────
                    _Feature(icon: Icons.auto_stories_outlined,
                      text: 'Unlimited personalized bedtime stories, fresh every night'),
                    _Feature(icon: Icons.restaurant_outlined,
                      text: 'Daily nutrition tips tailored to your child\'s exact age'),
                    _Feature(icon: Icons.favorite_border,
                      text: 'Health & symptom guidance — no more late-night Googling'),
                    _Feature(icon: Icons.people_outline,
                      text: 'Up to 3 child profiles, each growing with your family'),
                    _Feature(icon: Icons.auto_awesome_outlined,
                      text: 'AI-powered content, deduplicated and always fresh'),

                    const SizedBox(height: 20),

                    // ── Pricing toggle ────────────────────────────────────
                    Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _yearlySelected = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !_yearlySelected
                                ? TendlyColors.primary
                                : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !_yearlySelected
                                  ? TendlyColors.primary
                                  : TendlyColors.border)),
                            child: Column(children: [
                              Text('\$9.99/mo',
                                style: TextStyle(fontFamily: 'Poppins',
                                  fontSize: 16, fontWeight: FontWeight.w600,
                                  color: !_yearlySelected
                                    ? Colors.white
                                    : TendlyColors.primaryDeep)),
                              Text('Monthly',
                                style: TextStyle(fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: !_yearlySelected
                                    ? TendlyColors.primaryLight
                                    : TendlyColors.primaryDark)),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _yearlySelected = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _yearlySelected
                                ? TendlyColors.primary
                                : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _yearlySelected
                                  ? TendlyColors.primary
                                  : TendlyColors.border)),
                            child: Column(children: [
                              Text('\$79.99/yr',
                                style: TextStyle(fontFamily: 'Poppins',
                                  fontSize: 16, fontWeight: FontWeight.w600,
                                  color: _yearlySelected
                                    ? Colors.white
                                    : TendlyColors.primaryDeep)),
                              Text('Save 33%',
                                style: TextStyle(fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: _yearlySelected
                                    ? TendlyColors.primaryLight
                                    : TendlyColors.primaryDark)),
                            ]),
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Trial CTA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TendlyColors.primaryMist,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: TendlyColors.primaryLight)),
                      child: Row(children: [
                        const Icon(Icons.star_outline,
                          color: TendlyColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _yearlySelected
                              ? 'Start with 7 days free, then \$79.99/year'
                              : 'Start with 7 days free, then \$9.99/month',
                            style: const TextStyle(fontFamily: 'Poppins',
                              fontSize: 12, color: TendlyColors.primaryDark,
                              height: 1.4)),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _startTrial,
                      child: _isLoading
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white))
                        : const Text('Start 7-day free trial'),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Maybe later',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 13, color: TendlyColors.primaryDark)),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Cancel anytime · No commitment · Secure payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins',
                        fontSize: 11, color: TendlyColors.primaryLight)),
                    const SizedBox(height: 16),
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

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 28, height: 28,
        decoration: BoxDecoration(color: TendlyColors.primaryMist,
          shape: BoxShape.circle),
        child: Icon(Icons.check, color: TendlyColors.primary, size: 14)),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: const TextStyle(
        fontFamily: 'Poppins', fontSize: 13,
        color: TendlyColors.primaryDeep, height: 1.5))),
    ]),
  );
}
