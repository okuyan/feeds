import 'package:feeds/network/service_interface.dart';
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/network/result.dart';

class FeedService implements ServiceInterface {
  @override
  Future<RssFeed> getFeed(String url) async {
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
}
