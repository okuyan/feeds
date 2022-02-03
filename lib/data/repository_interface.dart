import 'models/models.dart';
import 'package:webfeed/webfeed.dart';

abstract class RepositoryInterface {
  List<Feed> getFeeds();
  Feed getFeed(int id);
  void addFeed(Feed feed);

  //Future<List<Feed>> findFeeds(String searchText);
  Future<RssFeed> downloadFeed(Uri url);

  List<Article> getArticles();
  Article getArticle(int id);
  void addArticle(Article article);

  Future initLocalDataSource();
  void close();
}
