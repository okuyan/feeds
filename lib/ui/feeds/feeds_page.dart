import 'package:feeds/ui/feeds/article_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:feeds/ui/feeds/article_list_page.dart';
import 'package:feeds/providers/app_providers.dart';
import 'package:feeds/ui/feeds/feed_view_model.dart';

class FeedsPage extends HookConsumerWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeds = ref.watch(feedViewModelProvider);

    final snapshot = useFuture(useMemoized(() {
      return ref.read(feedViewModelProvider.notifier).fetchFeeds(ref);
    }));

    return Scaffold(
      body: (feeds.isNotEmpty)
          ? ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (BuildContext _listContext, int index) {
                return ListTile(
                  title: Text(feeds[index].title),
                  onTap: () {
                    final selectedFeed = feeds[index];
                    ref.read(selectedFeedProvider.notifier).state =
                        selectedFeed;

                    ref
                        .read(articleListProvider.notifier)
                        .getArticles(feeds[index]);

                    Navigator.of(_listContext).push(
                      MaterialPageRoute(
                        builder: (context) => const ArticleListPage(),
                      ),
                    );
                  },
                  trailing: Text(feeds[index].articleCount.toString()),
                );
              })
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
