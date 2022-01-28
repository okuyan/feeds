import 'package:feeds/data/models/feed.dart';
import 'package:feeds/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFeedPage extends HookConsumerWidget {
  const AddFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _textController = useTextEditingController();

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
                                ref
                                    .read(searchResultFeedProvider.notifier)
                                    .state = [];
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
                          ref.read(searchResultFeedProvider.notifier).state = [
                            Feed(title: 'hoge', url: 'hoge', articleCount: 1),
                            Feed(title: 'hoge', url: 'hoge', articleCount: 1),
                          ];
                          // TODO call Feedly search API
                          // if there's result, show a feed title in ListView
                          // else "No result" message
                        }
                      },
                    ),
                  ],
                )),
          ),
          _buildFeedList(ref)
        ]));
  }

  Widget _buildFeedList(WidgetRef ref) {
    final List feeds = ref.watch(searchResultFeedProvider);

    return Expanded(
        child: Visibility(
            visible: feeds.isNotEmpty,
            child: ListView.builder(
                itemCount: feeds.length, // test
                itemBuilder: (context, index) {
                  return Text(feeds[index].title.toString());
                })));
  }
}
