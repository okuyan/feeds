import 'package:chopper/chopper.dart';
import 'package:webfeed/webfeed.dart';

import 'model_response.dart';

abstract class ServiceInterface {
  Future<Response<Result>> getFeed();
}
