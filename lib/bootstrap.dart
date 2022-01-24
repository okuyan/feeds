import 'package:feeds/state/article_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:feeds/data/hive_repository.dart';
import 'package:feeds/app_state_manager.dart';
import 'package:feeds/state/feeds_manager.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/network/feed_service.dart';
import 'package:webfeed/webfeed.dart';
import 'package:collection/collection.dart';

late StateNotifierProvider<FeedList, List<Feed>> feedListProvider;
late StateNotifierProvider<ArticleList, List<Article>> articleListProvider;
late StateProvider<Feed?> selectedFeedProvider;
late StateProvider<Article?> selectedArticleProvider;

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FeedAdapter());
  Hive.registerAdapter(ArticleAdapter());
  final repository = HiveRepository();
  await repository.init();

  int unread = 0;

  // TODO get feeds from repository
  final List<Feed> _feeds = repository.getAllFeeds();
  List<Article> _articles = [];

  if (_feeds.isEmpty) {
    // DL sample feed
    const sampleFeed = Feed(
        title: 'just sal\'s blog on nonbei alley',
        url: 'https://blog.salrashid.dev/index.xml',
        articleCount: 0);
    final sample = await FeedService().getFeed(sampleFeed.url);
    if (sample.items!.isNotEmpty) {
      final List<RssItem> _items = sample.items!;
      for (RssItem rssItem in _items) {
        var content = rssItem.description ?? rssItem.content;
        // TODO add articles
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
      unread += _items.length;
    }
  } else {
    // TODO get articles from repository
    List<Article> oldArticles = repository.getAllArticles();
    // TODO: DL feeds simultaneously
    // For now, DL each feed one by one
    for (final feed in _feeds) {
      // TODO download rss from URL for each site
      final RssFeed feedData = await FeedService().getFeed(feed.url);
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

        // TODO Check if article already exists
        Article? isExist =
            oldArticles.firstWhereOrNull((old) => old.link == rssItem.link);
        if (isExist != null) {
          // TODO check if isExist is unread, if so, count up unread++
          unread++;
          continue;
        }
        repository.addArticle(article);
      }
    }
  }

  // TODO sort articles by pubDate
  _articles.sort((b, a) => a.pubDate.compareTo(b.pubDate));

  feedListProvider = StateNotifierProvider<FeedList, List<Feed>>((ref) {
    return FeedList(_feeds);
  });

  articleListProvider =
      StateNotifierProvider<ArticleList, List<Article>>((ref) {
    return ArticleList(_articles);
  });

  selectedFeedProvider = StateProvider<Feed?>((ref) => null);
  selectedArticleProvider = StateProvider<Article?>((ref) => null);

  appStateManager.initializedApp();
}
