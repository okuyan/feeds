import 'dart:async';
import 'dart:io';

import 'package:feeds/data/models/feed.dart';
import 'package:feeds/data/remote/service/feedly_model.dart';
import 'package:feeds/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/ui/feeds/add_feed_view_model.dart';
import 'package:feeds/data/remote/result.dart';
import 'package:feeds/ui/feeds/feed_view_model.dart';
import 'package:webfeed/webfeed.dart';

import 'package:feeds/utils/DateTimeUtils.dart' as DateTimeUtils;

class AddFeedPage extends HookConsumerWidget {
  const AddFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _textController = useTextEditingController();
    final searchText = useState('');
    final showSearchResult = useState(false);
    final showIndicator = useState(false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Add feed', style: const TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
          elevation: 0,
        ),
        body: showIndicator.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          TextFormField(
                            //autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _textController,
                            decoration: InputDecoration(
                                hintText: 'Type a topic or paste a feed URL',
                                suffix: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _textController.clear();
                                      showSearchResult.value = false;
                                    })),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please type a keyword or paste the feed URL.';
                              }
                              return null;
                            },

                            onFieldSubmitted: (value) {
                              print('OnFieldSubmitted............');
                              searchText.value = _textController.text;
                              showSearchResult.value = true;
                            },
                          ),
                        ],
                      )),
                ),
                _buildFeedList(ref, searchText.value.trim(), showSearchResult,
                    showIndicator)
              ]));
  }

  void startSearch(WidgetRef ref, String searchText) {
    // fooderrich だと、ここでいろいろsetState()してる
  }

  Widget _buildFeedList(
      WidgetRef ref, search, showSearchResult, showIndicator) {
    final feeds = ref.watch(searchResultFeedProvider(search));
    final List<FeedlyResult> resultList = [];

    return Visibility(
        visible: showSearchResult.value,
        child: feeds.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            // TODO show error message
            error: (err, stack) => Text('error!!!!'),
            data: (feeds) {
              print('done........');
              if (feeds == null) {
                return const SizedBox.shrink();
              }

              final results = (feeds.body as Success).value;
              resultList.addAll(results.results);
              return Expanded(
                child: _buildSearchResultList(ref, resultList, showIndicator),
                /*
                  child: ListView.builder(
                      itemCount: resultList.length, // test
                      itemBuilder: (context, index) {
                        return Text(resultList[index].title.toString());
                      })*/
              );
            }));
  }

  Widget _buildSearchResultList(ref, resultList, showIndicator) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 18),
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          return _buildItemTile(ref, resultList[index], showIndicator);
        });
  }

  void addFeed(ref, item, showIndicator) async {
    // TODO show indicator
    showIndicator.value = true;
    // download feed
    final RssFeed rssFeed =
        await ref.read(repositoryProvider).downloadFeed(Uri.parse(item.feedId));

    final lastBuildDate = DateTimeUtils.DateUtils()
        .parseRfc822Date(rssFeed.lastBuildDate.toString());

    ref.read(feedViewModelProvider.notifier).add(
        rssFeed.title, item.feedId, rssFeed.items?.length ?? 0, lastBuildDate);
    item.isFollowed = true;
    showIndicator.value = false;
  }

  Widget _buildItemTile(ref, item, showIndicator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(item.title),
        trailing: item.isFollowed ? Icon(Icons.done) : Icon(Icons.add),
        onTap: () {
          if (item.isFollowed == false) {
            addFeed(ref, item, showIndicator);
          }
        },
      ),
    );
  }
}
