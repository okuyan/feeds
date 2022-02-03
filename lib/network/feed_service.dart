import 'package:feeds/network/service_interface.dart';
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/data/remote/result.dart';

class FeedService implements ServiceInterface {
  @override
  Future<RssFeed> getFeed(String url) async {
    print('Calling url: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      // TODO check response.body
      // since it could be HTML
      try {
        final feed = RssFeed.parse(response.body);
        return feed;
      } catch (e) {
        rethrow;
      }
    } else {
      // TODO error handling
      print(response.statusCode);
      throw Error(Exception());
    }
  }
}
