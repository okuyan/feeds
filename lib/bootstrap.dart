import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:feeds/data/hive_repository.dart';
import 'package:feeds/app_state_manager.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/network/feed_service.dart';
import 'package:feeds/data/sync/syncFeeds.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FeedAdapter());
  Hive.registerAdapter(ArticleAdapter());
  final repository = HiveRepository();
  await repository.init();

  await syncAllFeeds(repository, FeedService());
  appStateManager.initializedApp();
}
