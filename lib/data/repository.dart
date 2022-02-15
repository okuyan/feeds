import 'package:feeds/data/remote/remote_data_source.dart';
import 'package:feeds/data/repository_interface.dart';
import 'package:webfeed/webfeed.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:feeds/data/remote/service/feedly_service.dart';
import 'package:feeds/data/remote/service/feedly_model.dart';

import 'models/models.dart';

import 'package:feeds/data/remote/result.dart';
import 'package:chopper/chopper.dart';
import 'package:feeds/data/remote/result.dart';
import 'package:collection/collection.dart';

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

  List<Article> getArticlesByFeed(Feed feed) {
    return Hive.box<Article>('articleBox')
        .values
        .where((element) => element.feedId == feed.feedId)
        .toList();
  }

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

  Future syncFeeds() async {
    // get all feeds from local
    // if no feeds in local
    // add test feed

    // loop through to fetch the latest rss feed
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

  // close local db
  @override
  void close() {}
}
