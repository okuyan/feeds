import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:feeds/data/models/models.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FeedAdapter());
  Hive.registerAdapter(ArticleAdapter());

  final _feedBox = await Hive.openBox<Feed>('feedBox');
  final _articleBox = await Hive.openBox<Article>('articleBox');
}
