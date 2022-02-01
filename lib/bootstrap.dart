import 'package:feeds/data/repository.dart';
import 'package:feeds/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:feeds/data/hive_repository.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/network/feed_service.dart';
import 'package:get_it/get_it.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FeedAdapter());
  Hive.registerAdapter(ArticleAdapter());
  final repository = HiveRepository();
  await repository.init();

  final getIt = GetIt.instance;
  getIt.registerSingleton<Repository>(repository);

  getIt.registerSingleton<FeedService>(FeedService());

  initProviders();
}
