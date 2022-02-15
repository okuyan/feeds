import 'package:feeds/data/remote/service/feedly_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/repository.dart';
import 'package:chopper/chopper.dart';
import 'package:feeds/data/remote/result.dart';
import 'package:webfeed/webfeed.dart';

final searchResultFeedProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, searchString) async {
  print('In searchResultFeedProvider');
  print(searchString);

  if (searchString.isEmpty) {
    //return Future.delayed(const Duration(microseconds: 50), () => null);
    return null;
  }
  ref.maintainState = true;

  final trimmed = searchString.trim();
  final feedUrl = Uri.tryParse(trimmed);
  if (feedUrl != null && feedUrl.isAbsolute) {
    final feedData = await ref.read(repositoryProvider).downloadFeed(feedUrl);
    if (feedData is RssFeed || feedData is AtomFeed) {
      return feedData;
    }
  }

  return await ref.read(repositoryProvider).searchFeeds(searchString);
});
