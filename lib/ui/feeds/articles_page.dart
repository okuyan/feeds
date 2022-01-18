import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:feeds/network/feed_service.dart';
import 'package:feeds/models/models.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  static Page page({LocalKey? key}) => MaterialPage<void>(
        key: key,
        child: const ArticlesPage(),
      );

  @override
  _FeedsItemsPageState createState() => _FeedsItemsPageState();
}

class _FeedsItemsPageState extends State<ArticlesPage> {
  late RssFeed _rssFeed; // RSS Feed Object

  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
  }

  Future<RssFeed> getFeedData() async {
    final feedData = await FeedService().getFeed();
    return feedData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: _buildFeedLoader(context));
  }

  Widget _buildFeedLoader(BuildContext context) {
    return FutureBuilder<RssFeed>(
      future: getFeedData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString(),
                textAlign: TextAlign.center, textScaleFactor: 1.3),
          );
        }
        if (snapshot.hasData && snapshot.data!.items!.isNotEmpty) {
          final List<RssItem> _items = snapshot.data!.items!;

          for (RssItem rssItem in _items) {
            Article article = Article(
                title: rssItem.title.toString(),
                link: rssItem.link.toString(),
                content: rssItem.description);
            _articles.add(article);
          }
        }

        // Check to see if list has been populated
        for (Article article in _articles) {
          print('List contains: ${article.title}');
        }

        return _buildArticleList(context, _articles);
      },
    );
  }

  Future<void> launchArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return;
    }
  }

  Widget _buildArticleList(
      BuildContext articleListContext, List<Article> articles) {
    return Scaffold(
      appBar: AppBar(
        title: Text('salrashid blog feed'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _articles.length,
//          padding: EdgeInsets.all(8),
          itemBuilder: (BuildContext buildContext, int index) {
            return Container(
              child: ListTile(
                title: Text(_articles[index].title),
                onTap: () => launchArticle(_articles[index].link),
                trailing: Icon(Icons.arrow_right),
              ),
            );
          }),
    );
  }
}
