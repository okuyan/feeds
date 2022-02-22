import 'package:feeds/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:feeds/ui/feeds/article_list_page.dart';
import 'package:feeds/providers/app_providers.dart';
import 'package:feeds/ui/feeds/feed_view_model.dart';
import 'package:feeds/data/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FeedsPage extends HookConsumerWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeds = ref.watch(feedViewModelProvider);

    final snapshot = useFuture(useMemoized(() {
      //return ref.read(feedViewModelProvider.notifier).fetchFeeds();
      return ref.read(repositoryProvider).fetchFeeds();
    }));

    return Scaffold(
        body: ValueListenableBuilder<Box>(
            valueListenable: Hive.box<Feed>('feedBox').listenable(),
            builder: (context, box, widget) {
              return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    Feed currentFeed = box.getAt(index);

                    return Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            key: ValueKey(currentFeed.feedId),
                            onPressed: (BuildContext content) {
                              ref
                                  .read(repositoryProvider)
                                  .deleteFeed(currentFeed);
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          )
                        ]),
                        child: ListTile(
                            title: Text(currentFeed.title),
                            trailing: Text(currentFeed.articleCount.toString()),
                            onTap: () {
                              final selectedFeed = currentFeed;
                              ref.read(selectedFeedProvider.notifier).state =
                                  selectedFeed;

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ArticleListPage(),
                                ),
                              );
                            }));
                  });
            }));
  }
}
