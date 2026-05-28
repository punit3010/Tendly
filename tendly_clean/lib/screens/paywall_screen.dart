import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _yearlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: TendlyColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Column(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: TendlyColors.primaryDark,
                      borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.workspace_premium_outlined,
                      color: Colors.white, size: 32)),
                  const SizedBox(height: 14),
                  Text('Unlock Tendly Pro', style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Everything your child needs, every day',
                    style: GoogleFonts.poppins(fontSize: 13,
                      color: TendlyColors.primaryLight)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _feat('Unlimited personalized bedtime stories, fresh every night'),
                  _feat('Daily nutrition tips tailored to your child\'s exact age'),
                  _feat('Health & symptom guidance — no more late-night Googling'),
                  _feat('Up to 3 child profiles, growing with your family'),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: GestureDetector(
                      onTap: () => setState(() => _yearlySelected = false),
                      child: _priceCard('\$9.99/mo', 'Monthly', !_yearlySelected))),
                    const SizedBox(width: 10),
                    Expanded(child: GestureDetector(
                      onTap: () => setState(() => _yearlySelected = true),
                      child: _priceCard('\$79.99/yr', 'Save 33%', _yearlySelected))),
                  ]),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: Text('Start 7-day free trial',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Maybe later', style: GoogleFonts.poppins(
                      fontSize: 13, color: TendlyColors.primaryDark))),
                  const SizedBox(height: 6),
                  Text('Cancel anytime · No commitment',
                    style: GoogleFonts.poppins(fontSize: 11,
                      color: TendlyColors.primaryLight)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feat(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 22, height: 22,
        decoration: const BoxDecoration(
          color: TendlyColors.primaryMist, shape: BoxShape.circle),
        child: const Icon(Icons.check, color: TendlyColors.primary, size: 13)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.poppins(
        fontSize: 13, color: TendlyColors.primaryDeep, height: 1.5))),
    ]),
  );

  Widget _priceCard(String amt, String lbl, bool sel) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: sel ? TendlyColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: sel ? TendlyColors.primary : TendlyColors.border)),
    child: Column(children: [
      Text(amt, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,
        color: sel ? Colors.white : TendlyColors.primaryDeep)),
      Text(lbl, style: GoogleFonts.poppins(fontSize: 10,
        color: sel ? TendlyColors.primaryLight : TendlyColors.primaryDark)),
    ]),
  );
}
