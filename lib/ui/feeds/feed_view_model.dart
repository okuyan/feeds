import 'package:feeds/data/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:webfeed/webfeed.dart';
import 'package:collection/collection.dart';

final feedViewModelProvider =
    StateNotifierProvider<FeedViewModel, List<Feed>>((ref) {
  return FeedViewModel(repository: ref.read(repositoryProvider));
});

class FeedViewModel extends StateNotifier<List<Feed>> {
  FeedViewModel({required this.repository, List<Feed>? initialFeeds})
      : super(initialFeeds ?? []);

  final Repository repository;

  void add(
    String title,
    String url,
    int articleCount,
    String siteUrl,
  ) {
    // TODO adding new data to repository?

    repository.addFeed(Feed(
        title: title, url: url, articleCount: articleCount, siteUrl: siteUrl));

    state = [
      ...state,
      Feed(
          title: title, url: url, articleCount: articleCount, siteUrl: siteUrl),
    ];
  }

  void remove(Feed target) {
    // TODO removing data from repository

    state = state.where((feed) => feed.url != target.url).toList();
  }

  void replaceFeeds(List<Feed> feeds) {
    state = [...feeds];
  }

  Future<void> fetchFeeds() async {
    final List<Feed> _feeds = repository.getFeeds();
    List<Article> _articles = [];
    int _unread = 0;

    if (_feeds.isEmpty) {
      // DL sample feed
      final now = DateTime.now();
      final sampleFeed = Feed(
          title: 'just sal\'s blog on nonbei alley',
          url: 'https://blog.salrashid.dev/index.xml',
          articleCount: 0,
          siteUrl: 'https://blog.salrashid.dev/');
      final sample = await repository.downloadFeed(Uri.parse(sampleFeed.url));
      if (sample.items!.isNotEmpty) {
        final List<RssItem> _items = sample.items!;
        for (RssItem rssItem in _items) {
          var content = rssItem.description ?? rssItem.content;
          // Add articles
          Article article = Article(
              siteUrl: sampleFeed.siteUrl,
              title: rssItem.title.toString(),
              link: rssItem.link.toString(),
              unread: true,
              pubDate: rssItem.pubDate ?? DateTime.now(),
              content: content.toString());
          repository.addArticle(article);
          _articles.add(article);
        }
        final newFeed = sampleFeed.updateArticleCount(_items.length);
//        repository.addFeed(newFeed);

        add(newFeed.title, newFeed.url, newFeed.articleCount, newFeed.siteUrl);
        _feeds.add(newFeed);
        _unread += _items.length;
      }
    } else {
      List<Article> oldArticles = repository.getArticles();

      for (final feed in _feeds) {
        final RssFeed feedData =
            await repository.downloadFeed(Uri.parse(feed.url));
        if (feedData.items!.isEmpty) {
          continue;
        }

        for (RssItem rssItem in feedData.items!) {
          var content = rssItem.description ?? rssItem.content!.value;
          Article article = Article(
              siteUrl: feed.siteUrl,
              title: rssItem.title.toString(),
              link: rssItem.link.toString(),
              unread: true,
              content: content.toString(),
              pubDate: rssItem.pubDate ?? DateTime.now());
          _articles.add(article);

          // Check if article already exists
          Article? isExist =
              oldArticles.firstWhereOrNull((old) => old.link == rssItem.link);

          // Check if the existing article is unread, if so, count up unread++
          if (isExist != null && isExist.unread) {
            _unread++;
            continue;
          }
          repository.addArticle(article);
        }
      }
    }

    replaceFeeds(_feeds);

    // TODO
    // feed page では、記事を表示しないので、
    // 記事リストページのViewModelでHiveからデータをゲットして、ステートにセットする
  }
}
