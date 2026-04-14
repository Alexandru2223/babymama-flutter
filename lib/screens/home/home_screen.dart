import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../services/services.dart';
import 'home_models.dart';
import '_home_widgets.dart';
import 'profile_tab.dart';
import '../tracker/tracker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  HomeResponse? _homeData;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await homeRepository.fetch();
      if (!mounted) return;
      setState(() {
        _homeData = data;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Eroare de conexiune. Verifică internetul.';
        _loading = false;
      });
    }
  }

  // ── Home tab content ──────────────────────────────────────────────────────

  Widget _buildHomeTabContent() {
    // Loading — no data yet
    if (_loading && _homeData == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: BabyMamaColors.primary,
          strokeWidth: 2.5,
        ),
      );
    }

    // Error — no data to fall back on
    if (_error != null && _homeData == null) {
      return _HomeErrorState(message: _error!, onRetry: _loadHomeData);
    }

    final data = _homeData!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (always from server) ─────────────────────────────
          HomeHeader(
            greeting: data.header.greeting,
            subgreeting: data.header.subgreeting,
          ),

          // ── Baby section ────────────────────────────────────────────
          if (data.currentBaby == null)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: BabyMamaSpacing.xl2),
              child: NoBabyPrompt(
                onAddBaby: () =>
                    Navigator.pushNamed(context, '/onboarding/baby'),
              ),
            )
          else
            BabySummaryCard(
              baby: data.currentBaby!,
              babySummary: data.babySummary,
              insight: data.developmentInsight,
              onStartTracking: () => setState(() => _navIndex = 1),
            ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Quick add ───────────────────────────────────────────────
          QuickActionsSection(
            onActionTap: (_) {
              // TODO: open log bottom sheet per action
            },
          ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Today summary ───────────────────────────────────────────
          TodaySummaryCard(
            summary: data.todaySummary,
            onStartTracking: () => setState(() => _navIndex = 1),
          ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Development insight (optional) ──────────────────────────
          if (data.developmentInsight != null) ...[
            DevelopmentInsightCard(insight: data.developmentInsight!),
            const SizedBox(height: BabyMamaSpacing.xl3),
          ],

          // ── Community preview ───────────────────────────────────────
          CommunityPreviewSection(
            preview: data.communityPreview,
            onViewAll: () => setState(() => _navIndex = 2),
          ),

          const SizedBox(height: BabyMamaSpacing.xl3),

          // ── Tips preview ────────────────────────────────────────────
          TipsSection(
            preview: data.tipsPreview,
            onTipTap: (_) {
              // TODO: open tip detail screen
            },
          ),

          const SizedBox(height: BabyMamaSpacing.xl5),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BabyMamaColors.background,
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _navIndex,
        onIndexChanged: (i) => setState(() => _navIndex = i),
      ),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _navIndex,
          children: [
            // ── Tab 0: Home ──
            _buildHomeTabContent(),

            // ── Tab 1: Tracker ──
            const TrackerScreen(),

            // ── Tab 2: Comunitate (placeholder) ──
            const _PlaceholderTab(
              icon: Icons.people_outline_rounded,
              label: 'Comunitate',
              description:
                  'Conectează-te cu alte mămici și împărtășește experiențe.',
            ),

            // ── Tab 3: Profil ──
            const ProfileTab(),
          ],
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _HomeErrorState extends StatelessWidget {
  const _HomeErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: BabyMamaColors.primaryLight.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 28,
                color: BabyMamaColors.primary,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.lg),
            Text(
              'Hmm, ceva nu a mers',
              style: BabyMamaTypography.titleLarge.copyWith(
                color: BabyMamaColors.neutral900,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: BabyMamaTypography.bodyMedium.copyWith(
                color: BabyMamaColors.neutral500,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.xl2),
            PrimaryButton(label: 'Încearcă din nou', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

// ── Placeholder tab ───────────────────────────────────────────────────────────

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: BabyMamaSpacing.xl3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: BabyMamaColors.primaryLight.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(icon, size: 32, color: BabyMamaColors.primary),
            ),
            const SizedBox(height: BabyMamaSpacing.lg),
            Text(
              label,
              style: BabyMamaTypography.titleLarge.copyWith(
                color: BabyMamaColors.neutral900,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: BabyMamaTypography.bodyMedium.copyWith(
                color: BabyMamaColors.neutral500,
              ),
            ),
            const SizedBox(height: BabyMamaSpacing.xl2),
            Text(
              'În curând',
              style: BabyMamaTypography.labelSmall.copyWith(
                color: BabyMamaColors.accent,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
