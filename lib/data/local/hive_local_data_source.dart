import 'package:feeds/data/local/local_data_source.dart';
import 'package:hive/hive.dart';
import 'package:feeds/data/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late final FutureProvider hiveInfo;
late final FutureProvider hiveLocalDataSourceProvider;

class HiveLocalDataSource implements LocalDataSource {
//  late Box _feedBox;
//  late Box _articleBox;
  HiveLocalDataSource(Box feedBox, Box articleBox);

  @override
  List<Feed> getAllFeeds() {
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

  @override
  Feed getFeed(int id) {
    return Hive.box('feedBox').getAt(id);
  }

  @override
  List<Article> getAllArticles() {
    List<Article> _articles = [];
    List<int> _articleIds = Hive.box('articleBox').keys.cast<int>().toList();
    for (final id in _articleIds) {
      Article article = getArticle(id);
      _articles.add((getArticle(id)));
    }
    return _articles;
  }

  @override
  Article getArticle(int id) {
    return Hive.box('articleBox').getAt(id);
  }

  @override
  Future<void> init() async {
//    _feedBox = await Hive.openBox('feedBox');
//    _articleBox = await Hive.openBox('articleBox');
  }

  @override
  void addArticle(Article article) {
    Hive.box('articleBox').add(article);
  }

  @override
  void addFeed(Feed feed) {
    Hive.box('feedBox').add(feed);
  }

  @override
  void close() {}
}
