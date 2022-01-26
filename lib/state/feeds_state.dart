import 'package:riverpod/riverpod.dart';

import 'package:feeds/data/models/models.dart';

/// An object that controls a list of [Feed].
class FeedList extends StateNotifier<List<Feed>> {
  FeedList(List<Feed>? initialFeeds) : super(initialFeeds ?? []);

  void add(String title, String url, int articleCount) {
    // TODO adding new data to repository

    state = [
      ...state,
      Feed(title: title, url: url, articleCount: articleCount),
    ];
  }

  void remove(Feed target) {
    // TODO removing data from repository

    state = state.where((feed) => feed.url != target.url).toList();
  }
}
