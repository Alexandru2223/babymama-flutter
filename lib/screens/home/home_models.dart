// ─────────────────────────────────────────────────────────────────────────────
// Home API response models — map directly to GET /api/v1/home contract.
// Keep field names identical to JSON keys; parsing is done in fromJson only.
// ─────────────────────────────────────────────────────────────────────────────

// ── HomeHeaderData ────────────────────────────────────────────────────────────

class HomeHeaderData {
  const HomeHeaderData({
    required this.greeting,
    required this.subgreeting,
  });

  /// Server-rendered Romanian greeting, e.g. "Bună dimineața, Sofia!"
  final String greeting;

  /// Secondary line, e.g. "Iată cum se descurcă Ana astăzi"
  final String subgreeting;

  factory HomeHeaderData.fromJson(Map<String, dynamic> j) => HomeHeaderData(
        greeting: j['greeting'] as String,
        subgreeting: j['subgreeting'] as String,
      );
}

// ── CurrentBaby ───────────────────────────────────────────────────────────────

class CurrentBaby {
  const CurrentBaby({
    required this.id,
    required this.firstName,
    required this.birthDate,
    required this.ageInDays,
    required this.ageLabel,
    this.gender,
    required this.isPremature,
    this.birthWeightGrams,
  });

  final String id;
  final String firstName;
  final DateTime birthDate;
  final int ageInDays;

  /// Server-rendered Romanian age label, e.g. "7 luni și 1 zi"
  final String ageLabel;
  final String? gender; // "FEMALE" | "MALE" | "OTHER" | null
  final bool isPremature;
  final int? birthWeightGrams;

  /// Whole months completed — used for milestone copy.
  int get ageInMonths {
    final now = DateTime.now();
    int m = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (now.day < birthDate.day) m--;
    return m < 0 ? 0 : m;
  }

  /// Time-of-day tagline shown on the baby summary card.
  String get dailyTagline {
    final h = DateTime.now().hour;
    if (h < 12) return 'O dimineață frumoasă. Fiecare zi cu $firstName e unică.';
    if (h < 17) return 'Continuați rutina cu pași mici și liniștiți.';
    return 'O seară liniștită pentru $firstName și pentru tine.';
  }

  factory CurrentBaby.fromJson(Map<String, dynamic> j) => CurrentBaby(
        id: j['id'] as String,
        firstName: j['firstName'] as String,
        birthDate: DateTime.parse(j['birthDate'] as String),
        ageInDays: j['ageInDays'] as int,
        ageLabel: j['ageLabel'] as String,
        gender: j['gender'] as String?,
        isPremature: j['isPremature'] as bool? ?? false,
        birthWeightGrams: j['birthWeightGrams'] as int?,
      );
}

// ── BabySummary ───────────────────────────────────────────────────────────────

class BabySummary {
  const BabySummary({
    required this.isEmpty,
    this.lastFeed,
    this.lastSleep,
    this.lastDiaper,
  });

  /// true when no activities have been logged today.
  final bool isEmpty;

  /// Formatted label, e.g. "acum 2 ore", null when not logged today.
  final String? lastFeed;
  final String? lastSleep;
  final String? lastDiaper;

  factory BabySummary.fromJson(Map<String, dynamic> j) => BabySummary(
        isEmpty: j['isEmpty'] as bool,
        lastFeed: j['lastFeed'] as String?,
        lastSleep: j['lastSleep'] as String?,
        lastDiaper: j['lastDiaper'] as String?,
      );
}

// ── SleepToday ────────────────────────────────────────────────────────────────

class SleepToday {
  const SleepToday({
    required this.totalMinutes,
    required this.label,
    required this.hasOngoingSession,
  });

  final int totalMinutes;

  /// Server-rendered label, "–" when no sleep recorded today.
  final String label;
  final bool hasOngoingSession;

  factory SleepToday.fromJson(Map<String, dynamic> j) => SleepToday(
        totalMinutes: j['totalMinutes'] as int,
        label: j['label'] as String,
        hasOngoingSession: j['hasOngoingSession'] as bool? ?? false,
      );
}

// ── TodaySummary ──────────────────────────────────────────────────────────────

class TodaySummary {
  const TodaySummary({
    required this.sleep,
    required this.feedCount,
    required this.diaperCount,
    required this.isEmpty,
  });

  final SleepToday sleep;
  final int feedCount;
  final int diaperCount;

  /// true when zero activities have been logged today.
  final bool isEmpty;

  factory TodaySummary.fromJson(Map<String, dynamic> j) => TodaySummary(
        sleep: SleepToday.fromJson(j['sleep'] as Map<String, dynamic>),
        feedCount: j['feedCount'] as int,
        diaperCount: j['diaperCount'] as int,
        isEmpty: j['isEmpty'] as bool,
      );
}

// ── DevelopmentInsight ────────────────────────────────────────────────────────

class DevelopmentInsight {
  const DevelopmentInsight({
    required this.category,
    required this.ageRangeLabel,
    required this.title,
    required this.body,
    this.source,
  });

  /// "motor" | "cognitive" | "social" | "language" | "sensory" | "nutrition"
  final String category;
  final String ageRangeLabel;
  final String title;
  final String body;
  final String? source;

  factory DevelopmentInsight.fromJson(Map<String, dynamic> j) =>
      DevelopmentInsight(
        category: j['category'] as String,
        ageRangeLabel: j['ageRangeLabel'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        source: j['source'] as String?,
      );
}

// ── CommunityPostPreview ──────────────────────────────────────────────────────

class CommunityPostPreview {
  const CommunityPostPreview({
    required this.id,
    required this.tag,
    required this.title,
    required this.excerpt,
    required this.commentCount,
    required this.likeCount,
    required this.isPinned,
  });

  final String id;
  final String tag; // e.g. "somn"
  final String title;
  final String excerpt;
  final int commentCount;
  final int likeCount;

  /// isPinned is already applied server-side (pinned posts first) — UI only.
  final bool isPinned;

  factory CommunityPostPreview.fromJson(Map<String, dynamic> j) =>
      CommunityPostPreview(
        id: j['id'] as String,
        tag: j['tag'] as String,
        title: j['title'] as String,
        excerpt: j['excerpt'] as String,
        commentCount: j['commentCount'] as int,
        likeCount: j['likeCount'] as int,
        isPinned: j['isPinned'] as bool? ?? false,
      );
}

// ── CommunityPreview ──────────────────────────────────────────────────────────

class CommunityPreview {
  const CommunityPreview({required this.isEmpty, required this.posts});

  final bool isEmpty;
  final List<CommunityPostPreview> posts; // never null, may be empty

  factory CommunityPreview.fromJson(Map<String, dynamic> j) => CommunityPreview(
        isEmpty: j['isEmpty'] as bool,
        posts: (j['posts'] as List<dynamic>)
            .map((p) => CommunityPostPreview.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
}

// ── Tip ───────────────────────────────────────────────────────────────────────

class Tip {
  const Tip({
    required this.id,
    required this.category,
    required this.icon,
    required this.title,
    required this.body,
  });

  final String id;

  /// "somn" | "alaptare" | "dezvoltare" | "sanatate" | "nutritie"
  final String category;

  /// Semantic icon key: "moon" | "drop" | "baby" | "heart" |
  ///                    "leaf" | "sound" | "hands" | "sun"
  final String icon;

  final String title;
  final String body;

  factory Tip.fromJson(Map<String, dynamic> j) => Tip(
        id: j['id'] as String,
        category: j['category'] as String,
        icon: j['icon'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
      );
}

// ── TipsPreview ───────────────────────────────────────────────────────────────

class TipsPreview {
  const TipsPreview({required this.isEmpty, required this.items});

  final bool isEmpty;
  final List<Tip> items; // never null, may be empty

  factory TipsPreview.fromJson(Map<String, dynamic> j) => TipsPreview(
        isEmpty: j['isEmpty'] as bool,
        items: (j['items'] as List<dynamic>)
            .map((t) => Tip.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
}

// ── HomeResponse ──────────────────────────────────────────────────────────────

class HomeResponse {
  const HomeResponse({
    required this.header,
    this.currentBaby,
    required this.babySummary,
    required this.todaySummary,
    this.developmentInsight,
    required this.communityPreview,
    required this.tipsPreview,
  });

  final HomeHeaderData header;

  /// null for new users who haven't added a baby yet — show onboarding nudge.
  final CurrentBaby? currentBaby;

  final BabySummary babySummary;
  final TodaySummary todaySummary;

  /// null when no insight is available for this baby's age.
  final DevelopmentInsight? developmentInsight;

  final CommunityPreview communityPreview;
  final TipsPreview tipsPreview;

  factory HomeResponse.fromJson(Map<String, dynamic> j) => HomeResponse(
        header: HomeHeaderData.fromJson(j['header'] as Map<String, dynamic>),
        currentBaby: j['currentBaby'] != null
            ? CurrentBaby.fromJson(j['currentBaby'] as Map<String, dynamic>)
            : null,
        babySummary:
            BabySummary.fromJson(j['babySummary'] as Map<String, dynamic>),
        todaySummary:
            TodaySummary.fromJson(j['todaySummary'] as Map<String, dynamic>),
        developmentInsight: j['developmentInsight'] != null
            ? DevelopmentInsight.fromJson(
                j['developmentInsight'] as Map<String, dynamic>)
            : null,
        communityPreview: CommunityPreview.fromJson(
            j['communityPreview'] as Map<String, dynamic>),
        tipsPreview:
            TipsPreview.fromJson(j['tipsPreview'] as Map<String, dynamic>),
      );
}
