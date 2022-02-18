import 'package:feeds/ui/unread/unread_view_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:feeds/data/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/ui/feeds/article_page.dart';
import 'package:feeds/providers/app_providers.dart';
import 'package:feeds/ui/feeds/article_list_view_model.dart';
import 'package:feeds/ui/feeds/youtube_view.dart';

class ArticleListPage extends ConsumerWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  Future<void> launchArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the article list changes
    List<Article> _articles = ref.watch(articleListProvider);
    Feed? _selectedFeed = ref.watch(selectedFeedProvider);
    final _title = _selectedFeed!.title;

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
          title: Text(_title, style: const TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        body: ListView.builder(
            itemCount: _articles.length,
            itemBuilder: (BuildContext _listContext, int index) {
              return ListTile(
                title: Text(_articles[index].title),
                onTap: () {
                  // TODO toggle unread
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
                  ref.read(unreadProvider.notifier).getUnread();
                },
                trailing: const Icon(Icons.arrow_right),
              );
            }));
  }
}
