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
    List<Feed> _feeds = [];

    List<int> _feedIds = Hive.box('feedBox').keys.cast<int>().toList();
    if (_feedIds.isEmpty) {
      return _feeds;
    }

    for (final id in _feedIds) {
      _feeds.add((getFeed(id)));
    }
    return _feeds;
  }

  // get feed from local db
  @override
  Feed getFeed(int id) {
//    return _localDataSource.getFeed(id);
    return Hive.box('feedBox').getAt(id);
  }

  // add feed to local db
  @override
  void addFeed(Feed feed) {
//    _localDataSource.addFeed(feed);
    Hive.box('feedBox').add(feed);
  }

  // find feeds via API
  //@override
  //Future<List<Feed>> findFeeds(String searchText) async {}

  // download feed from uri
  @override
  Future<RssFeed> downloadFeed(Uri url) async {
    return await remoteDataSource.getFeed(url);
  }

  // get articles from local db
  @override
  List<Article> getArticles() {
    //return _localDataSource.getAllArticles();
    List<Article> _articles = [];
    List<int> _articleIds = Hive.box('articleBox').keys.cast<int>().toList();
    for (final id in _articleIds) {
      Article article = getArticle(id);
      _articles.add((getArticle(id)));
    }
    return _articles;
  }

  // get article from local db
  @override
  Article getArticle(int id) {
    //return _localDataSource.getArticle(id);
    return Hive.box('articleBox').getAt(id);
  }

  // add article to local db
  @override
  void addArticle(Article article) {
    //_localDataSource.addArticle(article);
    Hive.box('articleBox').add(article);
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

    // check lastBuildDate, if no update, skip
    // if updated, then update feed data
    // save articles data to local
  }

  @override
  Future<Response<Result<FeedlyResults>>> searchFeeds(String query) async {
    print('kdjgkldsjgklsdjgdlfkgjfdl');
    // call feedly service
    final feedlyService = FeedlyService.create();
    return await feedlyService.searchFeeds(query: query);
  }

  // close local db
  @override
  void close() {}
}
