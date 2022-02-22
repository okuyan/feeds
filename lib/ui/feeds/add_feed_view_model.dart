import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/repository.dart';
import 'package:webfeed/webfeed.dart';

final searchResultFeedProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, searchString) async {
  print('In searchResultFeedProvider');
  print(searchString);

  if (searchString.isEmpty) {
    return null;
  }

  final trimmed = searchString.trim();
  final feedUrl = Uri.tryParse(trimmed);
  if (feedUrl != null && feedUrl.isAbsolute) {
    final feedData = await ref.watch(repositoryProvider).downloadFeed(feedUrl);
    if (feedData is RssFeed || feedData is AtomFeed) {
      return feedData;
    }
  }

  return await ref.watch(repositoryProvider).searchFeeds(searchString);
});
