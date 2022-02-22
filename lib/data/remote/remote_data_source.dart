import 'package:webfeed/webfeed.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:feeds/data/remote/result.dart';

final remoteDataSourceProvider = Provider((ref) => RemoteDataSource());

class RemoteDataSource {
  Future<dynamic> getFeed(Uri url) async {
    print('Calling url: $url');
    final response = await get(url);
    if (response.statusCode == 200) {
      // TODO check response.body
      // since it could be HTML
      String decoded =
          const Utf8Decoder(allowMalformed: false).convert(response.bodyBytes);
      try {
        //final feed = RssFeed.parse(response.body);
        final feed = RssFeed.parse(decoded);
        return feed;
      } on ArgumentError {
        //final atom = AtomFeed.parse(response.body);
        final atom = AtomFeed.parse(decoded);
        return atom;
      }
    } else {
      // TODO error handling
      print(response.statusCode);
      throw Error(Exception());
    }
  }
}
