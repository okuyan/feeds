import 'package:riverpod/riverpod.dart';

import 'package:feeds/data/models/models.dart';

/// An object that controls a list of [Feed].
class ArticleList extends StateNotifier<List<Article>> {
  ArticleList(List<Article>? initialArticles) : super(initialArticles ?? []);

  void add(Article article) {
    state = [
      ...state,
      article,
    ];
  }

  void remove(Article target) {
    // TODO removing data from repository

    state = state.where((article) => article.link != target.link).toList();
  }

  void replaceArticles(List<Article> articles) {
    state.replaceRange(0, state.length, articles);
  }
}
