import 'models/models.dart';

abstract class Repository {
  List<Feed> getAllFeeds();
  Feed getFeed(int id);
  void addFeed(Feed feed);

  List<Article> getAllArticles();
  Article getArticle(int id);
  void addArticle(Article article);

  Future init();
  void close();
}
