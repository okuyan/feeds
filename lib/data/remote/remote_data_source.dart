import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:feeds/data/remote/result.dart';

final remoteDataSourceProvider = Provider((ref) => RemoteDataSource());

class RemoteDataSource {
  Future<RssFeed> getFeed(Uri url) async {
    print('Calling url: $url');
    final response = await get(url);
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
