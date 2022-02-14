import 'models/models.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/data/remote/result.dart';
import 'package:feeds/data/remote/service/feedly_model.dart';
import 'package:chopper/chopper.dart';

abstract class RepositoryInterface {
  List<Feed> getFeeds();
  //Feed? getFeed(int id);
  void addFeed(Feed feed);

  //Future<List<Feed>> findFeeds(String searchText);
  Future<dynamic> downloadFeed(Uri url);

  List<Article> getArticles();
//  Article? getArticle(int id);
  void addArticle(Article article);

  Future initLocalDataSource();

  Future<Response<Result<FeedlyResults>>> searchFeeds(String query);

  void close();
}
