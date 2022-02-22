import 'package:feeds/data/repository.dart';
import 'package:feeds/data/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final feedViewModelProvider =
    StateNotifierProvider<FeedViewModel, List<Feed>>((ref) {
  final feeds = ref.watch(repositoryProvider).getFeeds();
  if (feeds.isEmpty) {
    final sample = Feed(
        title: 'just sal\'s blog on nonbei alley',
        feedId: 'https://blog.salrashid.dev/index.xml',
        articleCount: 0,
        website: 'https://blog.salrashid.dev/');
    ref.watch(repositoryProvider).addFeed(sample);
    feeds.add(sample);
  }
  return FeedViewModel(ref: ref, initialFeeds: feeds);
});

class FeedViewModel extends StateNotifier<List<Feed>> {
  FeedViewModel({required this.ref, List<Feed>? initialFeeds})
      : super(initialFeeds ?? []);

  final Ref ref;

  void add(
    String title,
    String feedId,
    int articleCount,
    String website,
  ) {
    state = [
      ...state,
      Feed(
          title: title,
          feedId: feedId,
          articleCount: articleCount,
          website: website),
    ];
  }

  void remove(Feed target) {
    ref.read(repositoryProvider).deleteFeed(target);
    state = state.where((feed) => feed.feedId != target.feedId).toList();
  }

  void replaceFeeds(List<Feed> feeds) {
    state = [...feeds];
  }
}
