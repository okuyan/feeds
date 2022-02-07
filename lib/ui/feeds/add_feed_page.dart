import 'dart:async';

import 'package:feeds/data/models/feed.dart';
import 'package:feeds/data/remote/service/feedly_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/ui/feeds/add_feed_view_model.dart';
import 'package:feeds/data/remote/result.dart';

String _useDebouncedSearch(TextEditingController textEditingController) {
  final search = useState(textEditingController.text);
  useEffect(() {
    Timer? timer;
    void listener() {
      timer?.cancel();
      timer = Timer(const Duration(microseconds: 200),
          () => search.value = textEditingController.text);
    }

    textEditingController.addListener(listener);
    return () {
      timer?.cancel();
      textEditingController.removeListener(listener);
    };
  }, [textEditingController]);
  return search.value;
}

class AddFeedPage extends HookConsumerWidget {
  AddFeedPage({Key? key}) : super(key: key);
//  final List<Feed> searchResult = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _textController = useTextEditingController();
    useEffect(() {
      return _textController.dispose;
    }, [_textController]);
    final searchText = useState('');
    final showSearchResult = useState(false);

    //final search = _useDebouncedSearch(_textController);

    return Scaffold(
        appBar: AppBar(
          title: Text('Add feed', style: const TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromRGBO(227, 225, 224, 1.0),
          elevation: 0,
        ),
        body: Column(children: [
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

                                /*
                                ref
                                    .read(searchResultFeedProvider.notifier)
                                    .state = [];
                                */
                              })),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        print('validating');
                        print(value.toString());
                        if (value == null || value.isEmpty) {
                          return 'Please type a keyword or paste the feed URL.';
                        }
                        return null;
                      },

                      onFieldSubmitted: (value) {
                        print('OnFieldSubmitted............');

                        final _value = _textController.value;
                        // TODO validate url
                        //print(value.toString());
                        if (_formKey.currentState!.validate()) {
                          // Check if value is url
                          // if so,
                          if (Uri.tryParse(value.toString())!.hasAbsolutePath) {
                            print('this is a valid uri');
                            print(value.toString());
                            // TODO DL content
                            // if content is html, search rss feed in the content, if found, DL feed
                            //
                            // if rss feed exists, then show a feed title in ListView
                          } else {
                            print('this is not a valid uri');
                            searchText.value = _textController.text;
                            showSearchResult.value = true;

                            /*
                            ref.read(searchResultFeedProvider.notifier).state =
                                [
                              Feed(
                                  title: 'hoge',
                                  url: 'hoge',
                                  articleCount: 1,
                                  lastBuildDate: DateTime.now()),
                              Feed(
                                  title: 'hoge',
                                  url: 'hoge',
                                  articleCount: 1,
                                  lastBuildDate: DateTime.now()),
                            ];
                            */
                            // TODO call Feedly search API
                            // if there's result, show a feed title in ListView
                            // else "No result" message
                          }
                        }
                      },
                    ),
                  ],
                )),
          ),
          _buildFeedList(ref, searchText.value.trim(), showSearchResult)
        ]));
  }

  void startSearch(WidgetRef ref, String searchText) {
    // fooderrich だと、ここでいろいろsetState()してる
  }

  Widget _buildFeedList(WidgetRef ref, search, showSearchResult) {
    final feeds = ref.watch(searchResultFeedProvider(search));
    final List<FeedlyResult> resultList = [];

    return Visibility(
        visible: showSearchResult.value,
        child: feeds.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('error!!!!'),
            data: (feeds) {
              print('done........');
              if (feeds == null) {
                return const SizedBox.shrink();
              }

              final results = (feeds?.body as Success).value;
              resultList.addAll(results.results);
              return Expanded(
                  child: ListView.builder(
                      itemCount: resultList.length, // test
                      itemBuilder: (context, index) {
                        return Text(resultList[index].title.toString());
                      }));
            }));
  }
}
