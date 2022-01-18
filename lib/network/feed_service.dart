import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/network/result.dart';

const String apiUrl = 'https://blog.salrashid.dev/index.xml';

class FeedService {
  Future getData(String url) async {
    print('Calling url: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      // TODO error handling
      print(response.statusCode);
    }
  }

  Future<RssFeed> getFeed() async {
    final feedData = await getData(apiUrl);
    return feedData;
  }
}
