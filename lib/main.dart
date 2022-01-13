import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:feeds/models/models.dart';
import 'package:feeds/navigation/navigation.dart';
import 'package:feeds/feeds_theme.dart';

void main() {
  appStateManager.initializedApp();
  runApp(const FeedsApp());
}

class FeedsApp extends StatelessWidget {
  const FeedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appStateManager),
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
