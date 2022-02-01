import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:feeds/state/state.dart';
import 'package:feeds/data/models/models.dart';

late StateNotifierProvider<FeedList, List<Feed>> feedListProvider;
late StateNotifierProvider<ArticleList, List<Article>> articleListProvider;
late StateProvider<Feed?> selectedFeedProvider;
late StateProvider<Article?> selectedArticleProvider;
late StateProvider<int> unreadArticlesProvider;
late StateProvider<bool> dataLoadedProvideder;

late StateProvider<List<Feed?>> searchResultFeedProvider;

class FeedsTab {
  static const int allFeeds = 0;
  static const int unread = 1;
  static const int starred = 2;
}

late StateProvider<int> selectedTabProvider;

void initProviders() {
  feedListProvider = StateNotifierProvider<FeedList, List<Feed>>((ref) {
    return FeedList([]);
  });

  articleListProvider =
      StateNotifierProvider<ArticleList, List<Article>>((ref) {
    return ArticleList([]);
  });

  selectedFeedProvider = StateProvider<Feed?>((ref) => null);
  selectedArticleProvider = StateProvider<Article?>((ref) => null);
  unreadArticlesProvider = StateProvider<int>((ref) => 0);
  dataLoadedProvideder = StateProvider<bool>((ref) => false);

  // When adding a new feed, hold the search result
  searchResultFeedProvider = StateProvider<List<Feed?>>((ref) => []);

  // Form Home page tabs
  selectedTabProvider = StateProvider((ref) => FeedsTab.allFeeds);
}

void updateProviders(
    WidgetRef ref, List<Feed> feeds, List<Article> articles, int unread) {
  ref.read(feedListProvider.notifier).replaceFeeds(feeds);
  ref.read(articleListProvider.notifier).replaceArticles(articles);
  ref.read(dataLoadedProvideder.notifier).state = true;
}
