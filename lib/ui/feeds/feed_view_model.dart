import 'package:feeds/data/repository.dart';
import 'package:feeds/data/models/models.dart';
import 'package:webfeed/webfeed.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/utils/StripHtml.dart';

final feedViewModelProvider =
    StateNotifierProvider<FeedViewModel, List<Feed>>((ref) {
  final initialFeeds = ref.read(repositoryProvider).getFeeds();

  return FeedViewModel(ref: ref, initialFeeds: initialFeeds);
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

  Future<void> fetchFeeds() async {
    final List<Feed> _feeds = ref.read(repositoryProvider).getFeeds();

    if (_feeds.isEmpty) {
      // DL sample feed
      final sampleFeed = Feed(
          title: 'just sal\'s blog on nonbei alley',
          feedId: 'https://blog.salrashid.dev/index.xml',
          articleCount: 0,
          website: 'https://blog.salrashid.dev/');
      final sample = await ref
          .read(repositoryProvider)
          .downloadFeed(Uri.parse(sampleFeed.feedId));

      if (sample is RssFeed) {
        saveRssFeed(sample, sampleFeed.feedId);
      } else if (sample is AtomFeed) {
        saveAtomFeed(sample, sampleFeed.feedId);
      }

      final newFeed = sampleFeed.updateArticleCount(sample.items.length);

      // update state
      //add(newFeed.title, newFeed.feedId, newFeed.articleCount, newFeed.website);

    } else {
      List<Article> oldArticles = ref.read(repositoryProvider).getArticles();
      final List<Feed> updatedFeeds = [];

      for (final feed in _feeds) {
        final feedData = await ref
            .read(repositoryProvider)
            .downloadFeed(Uri.parse(feed.feedId));
        if (feedData.items!.isEmpty) {
          continue;
        }

        final newFeed = Feed(
            title: feed.title,
            feedId: feed.feedId,
            articleCount: feedData.items.length,
            website: feed.website);
        updatedFeeds.add(newFeed);

        if (feedData is RssFeed) {
          for (var i = 0; i < feedData.items!.length; i++) {
            // Check if article already exists
            Article? isExist = oldArticles
                .firstWhereOrNull((old) => old.link == feedData.items![i].link);
            // Check if the existing article is unread, if so, count up unread++
            if (isExist != null && isExist.unread) {
              continue;
            }

            saveRssItem(feedData.items![i], feed.feedId);
          }
        } else if (feedData is AtomFeed) {
          for (var i = 0; i < feedData.items!.length; i++) {
            // Check if article already exists
            Article? isExist = oldArticles.firstWhereOrNull((old) =>
                old.link.toString() == feedData.items![i].links![0].toString());
            // Check if the existing article is unread, if so, count up unread++
            if (isExist != null && isExist.unread) {
              continue;
            }
            saveAtomItem(feedData.items![i], feed.feedId);
          }
        }
        replaceFeeds(updatedFeeds);
      }
    }
  }

  void saveRssFeed(RssFeed rssFeed, String feedUrl) {
    ref.read(feedViewModelProvider.notifier).add(rssFeed.title.toString(),
        feedUrl, rssFeed.items?.length ?? 0, rssFeed.link.toString());
    final Feed newFeed = Feed(
        title: rssFeed.title.toString(),
        articleCount: rssFeed.items!.length,
        feedId: feedUrl,
        website: rssFeed.link.toString());
    ref.read(repositoryProvider).addFeed(newFeed);
    rssFeed.items?.forEach((element) {
      saveRssItem(element, feedUrl);
    });
  }

  void saveRssItem(RssItem item, String feedId) {
    String content = item.description ?? item.content!.value;
    content = stripHtmlIfNeeded(content);

    String articleLink = item.link.toString();
    DateTime? pubDate;
    if (item.pubDate != null) {
      pubDate = item.pubDate as DateTime;
    } else if (item.dc!.date != null) {
      pubDate = item.dc!.date as DateTime;
    }

    Article article = Article(
        feedId: feedId,
        title: item.title.toString(),
        link: articleLink,
        unread: true,
        content: content,
        pubDate: pubDate);
    ref.read(repositoryProvider).addArticle(article);
  }

  void saveAtomFeed(AtomFeed atomFeed, String feedId) {
    ref.read(feedViewModelProvider.notifier).add(
        atomFeed.title.toString(), feedId, atomFeed.items?.length ?? 0, feedId);
    final Feed newFeed = Feed(
        title: atomFeed.title.toString(),
        articleCount: atomFeed.items!.length,
        feedId: feedId,
        website: atomFeed.links![0].toString());
    ref.read(repositoryProvider).addFeed(newFeed);

    atomFeed.items?.forEach((element) {
      saveAtomItem(element, feedId);
    });
  }

  void saveRssItems(List<RssItem>? items, String feedId) {
    for (var i = 0; i < items!.length; i++) {
      saveRssItem(items[i], feedId);
    }
  }

  void saveAtomItem(AtomItem item, String feedId) {
    String content = '';
    String youTubeVideoId = '';
    if (item.content == null) {
      if (item.media!.group!.description != null) {
        content = item.media!.group!.description!.value.toString();
      }

      if (item.id != null) {
        final reg = RegExp('yt:video:');
        if (reg.hasMatch(item.id.toString())) {
          youTubeVideoId =
              item.id.toString().replaceFirst(RegExp('yt:video:'), '');
        }
      }
    } else if (item.content!.isNotEmpty) {
      content = item.content.toString();
    } else if (item.summary!.isNotEmpty) {
      content = item.summary.toString();
    }
    content = stripHtmlIfNeeded(content);

    String articleLink = '';
    if (item.links!.isNotEmpty) {
      articleLink = item.links![0].href.toString();
    }

    Article article = Article(
        feedId: feedId,
        title: item.title.toString(),
        link: articleLink,
        unread: true,
        content: content,
        pubDate: item.updated as DateTime,
        youTubeVideoId: youTubeVideoId);
    ref.read(repositoryProvider).addArticle(article);
  }

  void saveAtomItems(List<AtomItem>? items, WidgetRef ref, String feedId) {
    for (var i = 0; i < items!.length; i++) {
      saveAtomItem(items[i], feedId);
    }
  }
}
