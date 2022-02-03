import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final articleListProvider =
    StateNotifierProvider<ArticleList, List<Article>>((ref) {
  return ArticleList(repository: ref.read(repositoryProvider));
});

class ArticleList extends StateNotifier<List<Article>> {
  ArticleList({required this.repository, List<Article>? initialArticles})
      : super(initialArticles ?? []);

  final Repository repository;

  void getArticles() {
    final articles = repository.getArticles();
    state = [...articles];
  }

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
    state = [...articles];
  }
}
