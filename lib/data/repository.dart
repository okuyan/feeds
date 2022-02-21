import 'package:feeds/data/remote/remote_data_source.dart';
import 'package:feeds/data/repository_interface.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:feeds/data/remote/service/feedly_service.dart';
import 'package:feeds/data/remote/service/feedly_model.dart';

import 'models/models.dart';

import 'package:feeds/data/remote/result.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:feeds/utils/StripHtml.dart';
import 'package:webfeed/webfeed.dart';

final repositoryProvider = Provider((ref) => Repository(ref.read));

class Repository implements RepositoryInterface {
  Repository(this._reader);

  final Reader _reader;
  //late final _localDataSource;
  late final RemoteDataSource remoteDataSource =
      _reader(remoteDataSourceProvider);

/*
  Future<void> init() async {
    _localDataSource = await _reader(hiveLocalDataSourceProvider.future);
  }
*/
  // get feeds from local db
  @override
  List<Feed> getFeeds() {
//    return _localDataSource.getAllFeeds();

    return Hive.box<Feed>('feedBox').values.toList();
  }

  // add feed to local db
  @override
  void addFeed(Feed feed) {
//    _localDataSource.addFeed(feed);
    Hive.box<Feed>('feedBox').add(feed);
  }

  // find feeds via API
  //@override
  //Future<List<Feed>> findFeeds(String searchText) async {}

  // download feed from uri
  @override
  Future<dynamic> downloadFeed(Uri url) async {
    return await remoteDataSource.getFeed(url);
  }

  // get articles from local db
  @override
  List<Article> getArticles() {
    //return _localDataSource.getAllArticles();
    return Hive.box<Article>('articleBox').values.toList();
  }

  @override
  List<Article> getArticlesByFeed(Feed feed) {
    return Hive.box<Article>('articleBox')
        .values
        .where((element) => element.feedId == feed.feedId)
        .toList();
  }

  @override
  List<Article> getArticlesByUrl(Feed feed, String url) {
    return Hive.box<Article>('articleBox')
        .values
        .toList()
        .where(
            (article) => (article.link == url && article.feedId == feed.feedId))
        .toList();
  }

  // add article to local db
  @override
  void addArticle(Article article) {
    //_localDataSource.addArticle(article);

    // TODO check if exists
    final currentArticles = Hive.box<Article>('articleBox')
        .values
        .where((element) =>
            (element.link == article.link && element.feedId == article.feedId))
        .toList();
    if (currentArticles.isEmpty) {
      // if not, lets add it
      Hive.box<Article>('articleBox').add(article);
    }
  }

  // init local db
  @override
  Future initLocalDataSource() async {
//    await _localDataSource.init();
  }

  @override
  Future<Response<Result<FeedlyResults>>> searchFeeds(String query) async {
    // call feedly service
    final feedlyService = FeedlyService.create();
    final response = await feedlyService.searchFeeds(query: query);
    final searchResult = (response.body as Success).value;
    final results = searchResult.results;
    // TODO get current feeds in hive
    // Check if feed is already being followed
    var currentFeeds = getFeeds();
    for (var i = 0; i < results.length; i++) {
      final existing = currentFeeds
          .firstWhereOrNull((element) => element.feedId == results[i].feedId);
      if (existing == null) {
        continue;
      }
      currentFeeds.remove(existing);
      results[i].isFollowed = true;
    }

    (response.body as Success).value = FeedlyResults(results: results);
    return response;
  }

  @override
  Feed? findFeed(String feedId) {
    return Hive.box<Feed>('feedBox')
        .values
        .toList()
        .firstWhereOrNull((element) => element.feedId == feedId);
  }

  @override
  void deleteFeed(Feed feed) {
    final data = Hive.box<Feed>('feedBox')
        .values
        .toList()
        .firstWhereOrNull((element) => element.feedId == feed.feedId);
    if (data != null) {
      data.delete();
    }
    final articles = Hive.box<Article>('articleBox')
        .values
        .toList()
        .where((element) => element.feedId == feed.feedId);

    if (articles.isNotEmpty) {
      final keys = articles.map((element) => element.key);
      Hive.box<Article>('articleBox').deleteAll(keys);
    }
  }

  @override
  void updateArticle(Article article) {
    final data = Hive.box<Article>('articleBox')
        .values
        .toList()
        .firstWhereOrNull((element) =>
            element.feedId == article.feedId && element.link == article.link);
    if (data != null) {
      Hive.box<Article>('articleBox').putAt(data.key, article);
    }
  }

  // close local db
  @override
  void close() {}

  Future<void> fetchFeeds() async {
    final List<Feed> _feeds = getFeeds();
    List<Article> oldArticles = getArticles();

    for (final feed in _feeds) {
      final feedData = await downloadFeed(Uri.parse(feed.feedId));
      if (feedData.items!.isEmpty) {
        continue;
      }

      // TODO update articleCount????
      // articleCount should be the number of unread articles....

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
    }
  }

  void saveRssFeed(RssFeed rssFeed, String feedUrl) {
    final Feed newFeed = Feed(
        title: rssFeed.title.toString(),
        articleCount: rssFeed.items!.length,
        feedId: feedUrl,
        website: rssFeed.link.toString());
    addFeed(newFeed);
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
    addArticle(article);
  }

  void saveAtomFeed(AtomFeed atomFeed, String feedId) {
    final Feed newFeed = Feed(
        title: atomFeed.title.toString(),
        articleCount: atomFeed.items!.length,
        feedId: feedId,
        website: atomFeed.links![0].toString());
    addFeed(newFeed);

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
    addArticle(article);
  }

  void saveAtomItems(List<AtomItem>? items, WidgetRef ref, String feedId) {
    for (var i = 0; i < items!.length; i++) {
      saveAtomItem(items[i], feedId);
    }
  }
}
