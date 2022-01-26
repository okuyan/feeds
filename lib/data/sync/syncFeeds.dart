import 'package:webfeed/webfeed.dart';
import 'package:collection/collection.dart';

import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';
import 'package:feeds/network/service_interface.dart';
import 'package:feeds/providers/app_providers.dart';

Future<void> syncAllFeeds(
    Repository repository, ServiceInterface service) async {
  final List<Feed> _feeds = repository.getAllFeeds();
  List<Article> _articles = [];
  int _unread = 0;

  if (_feeds.isEmpty) {
    // DL sample feed
    const sampleFeed = Feed(
        title: 'just sal\'s blog on nonbei alley',
        url: 'https://blog.salrashid.dev/index.xml',
        articleCount: 0);
    final sample = await service.getFeed(sampleFeed.url);
    if (sample.items!.isNotEmpty) {
      final List<RssItem> _items = sample.items!;
      for (RssItem rssItem in _items) {
        var content = rssItem.description ?? rssItem.content;
        // Add articles
        Article article = Article(
            siteUrl: sampleFeed.url,
            title: rssItem.title.toString(),
            link: rssItem.link.toString(),
            unread: true,
            pubDate: rssItem.pubDate ?? DateTime.now(),
            content: content.toString());
        repository.addArticle(article);
        _articles.add(article);
      }
      final newFeed = sampleFeed.updateArticleCount(_items.length);
      repository.addFeed(newFeed);
      _feeds.add(newFeed);
      _unread += _items.length;
    }
  } else {
    List<Article> oldArticles = repository.getAllArticles();

    for (final feed in _feeds) {
      final RssFeed feedData = await service.getFeed(feed.url);
      if (feedData.items!.isEmpty) {
        continue;
      }

      for (RssItem rssItem in feedData.items!) {
        var content = rssItem.description ?? rssItem.content;
        Article article = Article(
            siteUrl: feed.url,
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
  // Sort articles by pubDate
  _articles.sort((b, a) => a.pubDate.compareTo(b.pubDate));

  initProviders(_feeds, _articles, _unread);
}
