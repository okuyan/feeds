import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:feeds/network/feed_service.dart';
import 'package:feeds/models/models.dart';

/*
class AllFeedsPage extends StatelessWidget {
  const AllFeedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('all feeds'),
    );
  }
}
*/

class AllFeedsPage extends StatefulWidget {
  const AllFeedsPage({Key? key}) : super(key: key);

  @override
  _AllFeedsPageState createState() => _AllFeedsPageState();
}

class _AllFeedsPageState extends State<AllFeedsPage> {
  late RssFeed _rssFeed; // RSS Feed Object

  List<Article> _articles = [];

  // Get the Medium RSSFeed data
  Future<RssFeed?> getRSSFeedData() async {
    try {
      final client = http.Client();
      final response =
          await client.get(Uri.parse('https://blog.salrashid.dev/index.xml'));
      return RssFeed.parse(response.body);
    } catch (e) {
      print(e);
    }
    return null;
  }

  updateFeed(feed) {
    setState(() {
      _rssFeed = feed;
    });
  }

  Future<void> launchArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    // Clear old data in the list
    _articles.clear();

    getRSSFeedData().then((feed) {
      // Update the _feed variable
      updateFeed(feed);

      // print feed Metadata
      print('FEED METADATA');
      print('------------------');
      print('Link: ${feed!.link}');
      print('Description: ${feed.description}');
      print('Docs: ${feed.docs}');
      print('Last build data: ${feed.lastBuildDate}');
      print('Number of items: ${feed.items!.length}');

      // Get the data for each item in the feed
      if (feed.items!.isNotEmpty) {
        /// Get the title of each item
        for (RssItem rssItem in feed.items!) {
          // Only print the titles of the articles: comments do not have a description (subtitle), but articles do
          if (rssItem.description != null) {
            // Create a new Medium article from the rssitem
            Article mediumArticle = Article(
                title: rssItem.title.toString(), link: rssItem.link.toString());

            // Add the article to the list
            _articles.add(mediumArticle);
          }
        }
      }

      // Check to see if list has been populated
      for (Article article in _articles) {
        print('List contains: ${article.title}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('salrashid blog feed'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _articles.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext buildContext, int index) {
          return Container(
            child: ListTile(
              title: Text(_articles[index].title),
//              subtitle: Text(_articles[index].datePublished),
              onTap: () => launchArticle(_articles[index].link),
              trailing: Icon(Icons.arrow_right),
            ),
          );
        },
      ),
    );
  }
}
