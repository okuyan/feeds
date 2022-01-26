import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feeds/ui/feeds/article_list_page.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/providers/app_providers.dart';

class FeedsPage extends ConsumerWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Feed> feeds = ref.watch(feedListProvider);
//    Feed? selectedFeed = ref.watch(selectedFeedProvider);

    return Scaffold(
      body: ListView.builder(
          itemCount: feeds.length,
          itemBuilder: (BuildContext _listContext, int index) {
            return ListTile(
              title: Text(feeds[index].title),
              onTap: () {
                ref.read(selectedFeedProvider.notifier).state = feeds[index];
                Navigator.of(_listContext).push(
                  MaterialPageRoute(
                    builder: (context) => const ArticleListPage(),
                  ),
                );
              },
              trailing: Text(feeds[index].articleCount.toString()),
            );
          }),
    );
  }
}
