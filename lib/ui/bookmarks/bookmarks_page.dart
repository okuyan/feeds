import 'package:feeds/data/models/article.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:feeds/providers/app_providers.dart';
import 'package:feeds/ui/feeds/article_page.dart';
import 'package:feeds/ui/feeds/youtube_view.dart';
import 'package:feeds/ui/bookmarks/bookmarks_view_model.dart';
import 'package:feeds/ui/feeds/article_list_view_model.dart';

class BookmarksPage extends HookConsumerWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const _title = 'Bookmarks';

    final List<Article> _articles = ref.watch(bookmarksProvider);
    return Scaffold(
        body: ListView.builder(
            itemCount: _articles.length,
            itemBuilder: (BuildContext _listContext, int index) {
              return ListTile(
                title: Text(_articles[index].title),
                onTap: () {
                  //  toggle unread
                  final hasReadArticle = ref
                      .read(articleListProvider.notifier)
                      .markHasRead(_articles[index]);
                  ref.read(selectedArticleProvider.notifier).state =
                      hasReadArticle;

                  // Check if article has youtube video id,
                  // if so, Navigate to youtube video player page
                  if (_articles[index].youTubeVideoId != null &&
                      _articles[index].youTubeVideoId != '') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const YouTubeView()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ArticlePage()));
                  }
                },
                trailing: const Icon(Icons.arrow_right),
              );
            }));
  }
}
