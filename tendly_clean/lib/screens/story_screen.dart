import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/story_service.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  String _theme = 'Adventure';
  bool _loading = false;
  String? _title;
  String? _body;
  String? _error;

  final _themes = ['Adventure','Animals','Magic','Space','Ocean','Friendship'];

  Future<void> _generate() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await StoryService.generateStory(
        childName: 'Aria',
        childAgeYears: 4,
        theme: _theme,
      );
      setState(() {
        _title = result['title'];
        _body  = result['story'];
      });
    } catch (e) {
      setState(() => _error = 'Could not generate story. Try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _generate(); // auto-generate on open
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: TendlyColors.primary,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(children: [
                const Icon(Icons.bedtime_outlined, color: Colors.white, size: 34),
                const SizedBox(height: 8),
                Text('Bedtime story', style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Personalized for Aria, age 4', style: GoogleFonts.poppins(
                  fontSize: 12, color: TendlyColors.primaryLight)),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pick a theme', style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: TendlyColors.primaryDeep)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _themes.map((t) {
                        final sel = t == _theme;
                        return GestureDetector(
                          onTap: () => setState(() => _theme = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? TendlyColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? TendlyColors.primary : TendlyColors.border)),
                            child: Text(t, style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w500,
                              color: sel ? Colors.white : TendlyColors.primaryDark)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: _loading ? null : _generate,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: Text(_loading ? 'Writing story...' : 'Generate new story',
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    if (_loading)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TendlyColors.border)),
                        child: Column(children: [
                          const CircularProgressIndicator(
                            color: TendlyColors.primary, strokeWidth: 2.5),
                          const SizedBox(height: 14),
                          Text('Writing a story for Aria...',
                            style: GoogleFonts.poppins(
                              fontSize: 13, color: TendlyColors.textSecondary)),
                        ]),
                      ),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCEBEB),
                          borderRadius: BorderRadius.circular(12)),
                        child: Text(_error!, style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.redAccent)),
                      ),
                    if (_title != null && _body != null && !_loading)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TendlyColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: TendlyColors.primaryMist,
                                borderRadius: BorderRadius.circular(20)),
                              child: Text('Tonight\'s story',
                                style: GoogleFonts.poppins(fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: TendlyColors.primaryDark)),
                            ),
                            const SizedBox(height: 10),
                            Text(_title!, style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w600,
                              color: TendlyColors.primaryDeep, height: 1.3)),
                            const SizedBox(height: 10),
                            Text(_body!, style: GoogleFonts.poppins(
                              fontSize: 14, color: TendlyColors.primaryDark,
                              height: 1.8)),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: _generate,
                                  icon: const Icon(Icons.refresh, size: 15,
                                    color: TendlyColors.primary),
                                  label: Text('New story', style: GoogleFonts.poppins(
                                    fontSize: 12, color: TendlyColors.primary))),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.bookmark_border, size: 15,
                                    color: TendlyColors.primary),
                                  label: Text('Save', style: GoogleFonts.poppins(
                                    fontSize: 12, color: TendlyColors.primary))),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: TendlyColors.primary,
        unselectedItemColor: TendlyColors.primaryLight,
        backgroundColor: Colors.white,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/home');
          if (i == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), activeIcon: Icon(Icons.auto_stories), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
