import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';

final searchResultFeedProvider = StateProvider<List<Feed?>>((ref) => []);
