import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/network/result.dart';

class FeedService {
  Future getData(String url) async {
    print('Calling url: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      // TODO error handling
      print(response.statusCode);
      throw Error(Exception());
    }
  }

  Future<RssFeed> getFeed(String apiUrl) async {
    final feedData = await getData(apiUrl);
    return feedData;
  }
}
