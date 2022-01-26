import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feeds/state/state.dart';
import 'package:feeds/data/models/models.dart';

late StateNotifierProvider<FeedList, List<Feed>> feedListProvider;
late StateNotifierProvider<ArticleList, List<Article>> articleListProvider;
late StateProvider<Feed?> selectedFeedProvider;
late StateProvider<Article?> selectedArticleProvider;
late StateProvider<int> unreadArticlesProvider;

void initProviders(List<Feed> feeds, List<Article> articles, int unread) {
  feedListProvider = StateNotifierProvider<FeedList, List<Feed>>((ref) {
    return FeedList(feeds);
  });

  articleListProvider =
      StateNotifierProvider<ArticleList, List<Article>>((ref) {
    return ArticleList(articles);
  });

  selectedFeedProvider = StateProvider<Feed?>((ref) => null);
  selectedArticleProvider = StateProvider<Article?>((ref) => null);
  unreadArticlesProvider = StateProvider<int>((ref) => unread);
}
