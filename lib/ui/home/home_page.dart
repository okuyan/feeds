import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:feeds/ui/feeds/feeds_page.dart';
import 'package:feeds/ui/unread/unread_page.dart';
import 'package:feeds/ui/starred/starred_page.dart';
//import 'package:feeds/models/models.dart';
import 'package:feeds/app_state_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page({LocalKey? key}) =>
      MaterialPage<void>(key: key, child: const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Widget> pages = [
    const FeedsPage(),
    const UnreadPage(),
    const StarredPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
        builder: (context, appStateManager, child) {
      String title;
      switch (appStateManager.selectedTab) {
        case FeedsTab.allFeeds:
          title = 'All Feeds';
          break;
        case FeedsTab.unread:
          title = 'Unread';
          break;
        case FeedsTab.starred:
          title = 'Starred';
          break;
        default:
          title = 'Unread';
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
          title: Text(title, style: const TextStyle(color: Colors.black87)),
          elevation: 0,
        ),
        body: SafeArea(
          child: IndexedStack(
            index: appStateManager.selectedTab,
            children: pages,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: appStateManager.selectedTab,
          onTap: appStateManager.goToTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'All feeds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'Unread',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Starred',
            ),
          ],
        ),
      );
    });
  }
}
