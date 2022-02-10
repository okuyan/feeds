import 'package:feeds/data/remote/service/feedly_model.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';
import 'package:chopper/chopper.dart';
import 'package:feeds/data/remote/result.dart';

final searchResultFeedProvider = FutureProvider.autoDispose
    .family<Response<Result<FeedlyResults>>?, String>(
        (ref, searchString) async {
  print('In searchResultFeedProvider');
  print(searchString);

  if (searchString.isEmpty) {
    //return Future.delayed(const Duration(microseconds: 50), () => null);
    return null;
  }
  ref.maintainState = true;
  return await ref.read(repositoryProvider).searchFeeds(searchString);
});
