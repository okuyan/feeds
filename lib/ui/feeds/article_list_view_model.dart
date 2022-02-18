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

  void getArticles(Feed feed) {
    final articles = repository.getArticlesByFeed(feed);
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

  Article markHasRead(Article target) {
    final hasReadArticle = target.updateUnread(false);
    state = [
      for (final article in state)
        if (article.link == target.link && article.feedId == target.feedId)
          hasReadArticle
        else
          article
    ];

    // Update article in repository
    repository.updateArticle(hasReadArticle);
    return hasReadArticle;
  }

  Article toggleUnread(Article target) {
    final toggledArticle = target.updateUnread(!target.unread);
    state = [
      for (final article in state)
        if (article.link == target.link && article.feedId == target.feedId)
          toggledArticle
        else
          article
    ];

    // Update article in repository
    repository.updateArticle(toggledArticle);
    return toggledArticle;
  }

  Article toggleBookmarked(Article target) {
    final toggledArticle = target.updateBookmarked(!target.bookmarked);

    state = [
      for (final article in state)
        if (article.link == target.link && article.feedId == target.feedId)
          toggledArticle
        else
          article
    ];

    // Update article in repository
    repository.updateArticle(toggledArticle);
    return toggledArticle;
  }
}

/*
final bookmarkedArticles = Provider<List<Article>>((ref) {
  final articles = ref.read(repositoryProvider).getArticles();
  return articles.where((element) => element.bookmarked == true).toList();
});
*/
