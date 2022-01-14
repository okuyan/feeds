import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/network/result.dart';

const String apiUrl = 'https://blog.salrashid.dev/index.xml';

class FeedService {
  // 1
  Future getData(String url) async {
    // 2
    print('Calling url: $url');
    // 3
    final response = await get(Uri.parse(url));
    // 4
    if (response.statusCode == 200) {
      // 5
      return RssFeed.parse(response.body);
    } else {
      // 6
      print(response.statusCode);
    }
  }

  Future<RssFeed> getFeed() async {
    final feedData = await getData(apiUrl);
    print(feedData);
    return feedData;
  }
}
