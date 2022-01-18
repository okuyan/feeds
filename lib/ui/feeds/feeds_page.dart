import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:feeds/ui/feeds/articles_page.dart';
import 'package:feeds/models/models.dart';
import 'package:go_router/go_router.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  late RssFeed _rssFeed; // RSS Feed Object

  List<Feed> _feeds = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Feed>> getFeedsData() async {
    // 各フィードのアイテムもこの段階でなきゃだめ。
    // homeページを表示する前に、全フィードをDLしておく？？？
    _feeds.add(Feed(
        title: 'blog.salrashid.dev',
        url: 'https://blog.salrashid.dev/index.xml'));
    _feeds.add(Feed(
        title: 'blog.salrashid.dev',
        url: 'https://blog.salrashid.dev/index.xml'));
    return Future.delayed(
      const Duration(seconds: 2),
      () => _feeds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: _buildFeedLoader(context));
  }

  Widget _buildFeedLoader(BuildContext context) {
    return FutureBuilder<List<Feed>>(
      future: getFeedsData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString(),
                textAlign: TextAlign.center, textScaleFactor: 1.3),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildArticleList(context, snapshot.data!);
        }
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  Widget _buildArticleList(BuildContext _listContext, List<Feed> _feeds) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _feeds.length,
//          padding: EdgeInsets.all(8),
          itemBuilder: (BuildContext _listContext, int index) {
            return Container(
              child: ListTile(
                title: Text(_feeds[index].title),
                onTap: () => Navigator.of(_listContext).push(MaterialPageRoute(
                  builder: (context) => ArticlesPage(),
                )),
                trailing: Text('10'),
              ),
            );
          }),
    );
  }

  Widget _buildBareWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('hgoehgeo'),
    );
  }
}
