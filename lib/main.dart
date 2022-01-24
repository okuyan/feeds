import 'package:feeds/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as og_provider;

import 'package:feeds/navigation/navigation.dart';
import 'package:feeds/feeds_theme.dart';
import 'package:feeds/app_state_manager.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const ProviderScope(child: FeedsApp()));
}

class FeedsApp extends StatelessWidget {
  const FeedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return og_provider.MultiProvider(
      providers: [
        og_provider.ChangeNotifierProvider(
            create: (context) => appStateManager),
      ],
      child: MaterialApp.router(
          title: 'Feeds',
          theme: FeedsTheme.light(),
          darkTheme: FeedsTheme.dark(),
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate),
    );
  }
}
