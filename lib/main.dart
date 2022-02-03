import 'package:feeds/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:feeds/navigation/navigation.dart';
import 'package:feeds/feeds_theme.dart';

Future<void> main() async {
  await bootstrap();

  runApp(const ProviderScope(child: FeedsApp()));
}

class FeedsApp extends HookConsumerWidget {
  const FeedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
        title: 'Feeds',
        theme: FeedsTheme.light(),
        darkTheme: FeedsTheme.dark(),
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate);
  }
}
