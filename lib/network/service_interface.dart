import 'package:webfeed/webfeed.dart';

abstract class ServiceInterface {
  Future<RssFeed> getFeed(String url);
}
