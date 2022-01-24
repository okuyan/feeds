import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:feeds/data/models/models.dart';
import 'package:feeds/bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feeds/ui/feeds/article_page.dart';

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
    List<Article> _articles = ref.watch(articleListProvider);
    Feed? _selectedFeedProvider = ref.watch(selectedFeedProvider);
    final _title = _selectedFeedProvider!.title;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Color.fromRGBO(227, 225, 224, 1.0),
          title: Text(_title, style: TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        body: ListView.builder(
            itemCount: _articles.length,
            itemBuilder: (BuildContext _listContext, int index) {
              return ListTile(
                title: Text(_articles[index].title),
                onTap: () {
                  ref.read(selectedArticleProvider.notifier).state =
                      _articles[index];
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ArticlePage()));
                },
                trailing: const Icon(Icons.arrow_right),
              );
            }));
  }
}
