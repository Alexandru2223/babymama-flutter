// Models and mock data for the Home screen.
// Shape is designed to mirror future API response objects so that
// replacing mock data with real API calls only requires changing
// how these classes are populated, not how they are consumed.

// ── Models ────────────────────────────────────

class BabyHomeData {
  const BabyHomeData({
    required this.id,
    required this.name,
    required this.birthDate,
  });

  final String id;
  final String name;
  final DateTime birthDate;

  /// e.g. "2 luni și 5 zile" / "3 luni" / "15 zile"
  String get ageLabel {
    final now = DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    int days = now.day - birthDate.day;
    if (days < 0) {
      months -= 1;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) months = 0;
    if (months == 0) return '$days ${days == 1 ? 'zi' : 'zile'}';
    if (days == 0) return '$months ${months == 1 ? 'lună' : 'luni'}';
    return '$months ${months == 1 ? 'lună' : 'luni'} '
        'și $days ${days == 1 ? 'zi' : 'zile'}';
  }

  /// Whole months completed — used for milestone copy.
  int get ageInMonths {
    final now = DateTime.now();
    int m =
        (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (now.day < birthDate.day) m -= 1;
    return m < 0 ? 0 : m;
  }

  /// Time-of-day tagline shown on the baby summary card.
  String get dailyTagline {
    final h = DateTime.now().hour;
    if (h < 12) return 'O dimineață frumoasă. Fiecare zi cu $name e unică.';
    if (h < 17) return 'Continuați rutina cu pași mici și liniștiți.';
    return 'O seară liniștită pentru $name și pentru tine.';
  }
}

class TodayStats {
  const TodayStats({
    required this.sleepMinutes,
    required this.mealCount,
    required this.diaperCount,
  });

  final int sleepMinutes;
  final int mealCount;
  final int diaperCount;

  String get sleepLabel {
    final h = sleepMinutes ~/ 60;
    final m = sleepMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }
}

class DevelopmentInsight {
  const DevelopmentInsight({
    required this.ageRangeLabel,
    required this.text,
    required this.emoji,
    required this.category,
  });

  final String ageRangeLabel;
  final String text;
  final String emoji;
  final String category;
}

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timeAgo,
    required this.likeCount,
    required this.replyCount,
  });

  final String id;
  final String authorName;
  final String content;
  final String timeAgo;
  final int likeCount;
  final int replyCount;

  String get authorInitial =>
      authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';
}

class ContentTip {
  const ContentTip({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.emoji,
    required this.readMinutes,
  });

  final String id;
  final String title;
  final String categoryLabel;
  final String emoji;
  final int readMinutes;

  String get readLabel => '$readMinutes min · citire';
}

// ── Mock data ─────────────────────────────────

const mockUserName = 'Ana';

final mockBaby = BabyHomeData(
  id: 'mock-baby-1',
  name: 'Maya',
  birthDate: DateTime.now().subtract(const Duration(days: 65)),
);

const mockTodayStats = TodayStats(
  sleepMinutes: 260, // 4h 20m
  mealCount: 3,
  diaperCount: 2,
);

const mockDevelopmentInsight = DevelopmentInsight(
  ageRangeLabel: '2 luni',
  text: 'La această vârstă, bebe poate începe să urmărească obiecte cu '
      'privirea și să zâmbească mai des. Vorbitul cu ea îi stimulează '
      'dezvoltarea limbajului.',
  emoji: '🌱',
  category: 'Dezvoltare',
);

const mockCommunityPosts = [
  CommunityPost(
    id: 'post-1',
    authorName: 'Andreea',
    content:
        'Bebelușul meu se trezește foarte des noaptea. Ați trecut prin asta?',
    timeAgo: 'acum 2h',
    likeCount: 14,
    replyCount: 7,
  ),
  CommunityPost(
    id: 'post-2',
    authorName: 'Maria',
    content:
        'La noi a ajutat mult o rutină liniștită de seară: baie caldă, masaj, cântecel. ❤️',
    timeAgo: 'acum 4h',
    likeCount: 28,
    replyCount: 3,
  ),
];

const mockContentTips = [
  ContentTip(
    id: 'tip-1',
    title: 'Cum construiești o rutină de somn mai liniștită',
    categoryLabel: 'Somn & odihnă',
    emoji: '😴',
    readMinutes: 5,
  ),
  ContentTip(
    id: 'tip-2',
    title: 'Semne normale de dezvoltare în primele luni',
    categoryLabel: 'Creștere & dezvoltare',
    emoji: '🌟',
    readMinutes: 7,
  ),
];
