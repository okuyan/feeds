import 'package:feeds/data/models/article.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:feeds/feeds_theme.dart';
import 'package:feeds/providers/app_providers.dart';

class YouTubeView extends ConsumerWidget {
  const YouTubeView({Key? key}) : super(key: key);

  Future<void> launchArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedArticle = ref.watch(selectedArticleProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black38),
        backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
        elevation: 0,
      ),
      body: ListView(
        //padding: const EdgeInsets.all(7),
        children: [
          InkWell(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  selectedArticle!.title,
                  style: FeedsTheme.lightTextTheme.headline1,
                )),
            onTap: () => launchArticle(selectedArticle.link),
          ),
          Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                selectedArticle.pubDate.toString(),
                style: const TextStyle(fontSize: 11),
              )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildYouTubePlayer(selectedArticle),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              selectedArticle.content.toString(),
              style: FeedsTheme.lightTextTheme.bodyText2,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //selectedItemColor: Theme.of(context).colorScheme.secondary,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article_outlined,
            ),
            label: 'hoge',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.mark_as_unread), label: 'hoge'),
        ],
      ),
    );
  }

  YoutubePlayer _buildYouTubePlayer(Article article) {
    final _controller = YoutubePlayerController(
        initialVideoId: article.youTubeVideoId.toString(),
        flags: YoutubePlayerFlags(autoPlay: false));
    return YoutubePlayer(
      controller: _controller,
    );
  }
}
