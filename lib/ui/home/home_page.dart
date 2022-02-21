import 'package:feeds/providers/app_providers.dart';
import 'package:feeds/ui/feeds/feed_view_model.dart';
import 'package:flutter/material.dart';

import 'package:feeds/ui/feeds/feeds_page.dart';
import 'package:feeds/ui/unread/unread_page.dart';
import 'package:feeds/ui/bookmarks/bookmarks_page.dart';
import 'package:feeds/ui/feeds/add_feed_page.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Some keys used for testing
final addFeedKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page({LocalKey? key}) =>
      MaterialPage<void>(key: key, child: const HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static List<Widget> pages = [
    const FeedsPage(),
    const UnreadPage(),
    const BookmarksPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void goToTab(index) {
    ref.read(selectedTabProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedTabProvider);
    late String title;

    switch (selectedTab) {
      case FeedsTab.allFeeds:
        title = 'All Feeds';
        break;
      case FeedsTab.unread:
        title = 'Unread';
        break;
      case FeedsTab.bookmarks:
        title = 'Bookmarks';
        break;
      default:
        title = 'Unread';
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
          title: Text(title, style: const TextStyle(color: Colors.black87)),
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddFeedPage()));
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                    color: Colors.black54,
                  ),
                )),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              ref.refresh(feedViewModelProvider.notifier).fetchFeeds(),
          displacement: 0.0,
          color: Colors.black54,
          backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
          child: SafeArea(
            child: IndexedStack(
              index: selectedTab,
              children: pages,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: goToTab,
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
              label: 'Bookmarks',
            ),
          ],
        ),
      ),
    );
  }
}
