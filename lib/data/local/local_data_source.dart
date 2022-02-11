import 'package:feeds/data/models/models.dart';

abstract class LocalDataSource {
  List<Feed> getAllFeeds();
  Feed getFeed(int id);
  void addFeed(Feed feed);

  List<Article> getAllArticles();
  Article getArticle(int id);
  void addArticle(Article article);

  Future init();
  void close();
}
