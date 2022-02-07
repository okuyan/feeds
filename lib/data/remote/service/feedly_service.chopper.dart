// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedly_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$FeedlyService extends FeedlyService {
  _$FeedlyService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = FeedlyService;

  @override
  Future<Response<Result<FeedlyResults>>> searchFeeds(
      {required String query, int count = 30}) {
    final $url = '/search/feeds';
    final $params = <String, dynamic>{'query': query, 'count': count};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Result<FeedlyResults>, FeedlyResults>($request);
  }
}
