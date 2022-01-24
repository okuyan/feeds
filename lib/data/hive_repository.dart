import 'package:feeds/data/repository.dart';
import 'package:hive/hive.dart';
import 'package:feeds/data/models/models.dart';

class HiveRepository extends Repository {
  late Box _feedBox;
  late Box _articleBox;

  @override
  List<Feed> getAllFeeds() {
    List<Feed> _feeds = [];

    List<int> _feedIds = _feedBox.keys.cast<int>().toList();
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
    return _feedBox.getAt(id);
  }

  @override
  List<Article> getAllArticles() {
    List<Article> _articles = [];
    List<int> _articleIds = _articleBox.keys.cast<int>().toList();
    for (final id in _articleIds) {
      Article article = getArticle(id);
      _articles.add((getArticle(id)));
    }
    return _articles;
  }

  @override
  Article getArticle(int id) {
    return _articleBox.getAt(id);
  }

  @override
  Future<void> init() async {
    _feedBox = await Hive.openBox('feedBox');
    _articleBox = await Hive.openBox('articleBox');
  }

  @override
  void addArticle(Article article) {
    _articleBox.add(article);
  }

  @override
  void addFeed(Feed feed) {
    _feedBox.add(feed);
  }

  @override
  void close() {}
}
