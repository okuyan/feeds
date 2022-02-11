import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';

final selectedFeedProvider = StateProvider<Feed?>((ref) => null);
final selectedArticleProvider = StateProvider<Article?>((ref) => null);

// Form Home page tabs
final selectedTabProvider = StateProvider((ref) => FeedsTab.allFeeds);

class FeedsTab {
  static const int allFeeds = 0;
  static const int unread = 1;
  static const int starred = 2;
}
