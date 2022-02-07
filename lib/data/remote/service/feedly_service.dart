import 'package:chopper/chopper.dart';
import 'package:feeds/data/remote/service/feedly_model.dart';

import 'package:feeds/data/remote/result.dart';
import 'package:feeds/data/remote/service/feedly_service_converter.dart';
part 'feedly_service.chopper.dart';

const baseUrl = 'https://cloud.feedly.com/v3';

@ChopperApi()
abstract class FeedlyService extends ChopperService {
  @Get(path: '/search/feeds')
  Future<Response<Result<FeedlyResults>>> searchFeeds(
      {@Query('query') required String query, @Query('count') int count = 30});

  static FeedlyService create() {
    final client = ChopperClient(
      baseUrl: baseUrl,
      interceptors: [HttpLoggingInterceptor()],
      converter: FeedlyServiceConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$FeedlyService(),
      ],
    );
    return _$FeedlyService(client);
  }
}
