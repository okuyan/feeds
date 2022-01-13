import 'package:feeds/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:feeds/features/splash/splash_page.dart';

class Routes {
  static final splash = GoRoute(
      path: '/splash',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          SplashPage.page(key: state.pageKey));

  static final home = GoRoute(
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          HomePage.page(key: state.pageKey));
}
