import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final articleListProvider =
    StateNotifierProvider<ArticleList, List<Article>>((ref) {
  return ArticleList(ref: ref);
});

class ArticleList extends StateNotifier<List<Article>> {
  ArticleList({required this.ref, List<Article>? initialArticles})
      : super(initialArticles ?? []);

  final Ref ref;

  void getArticles(Feed feed) {
    final articles = ref.read(repositoryProvider).getArticlesByFeed(feed);
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
    ref.read(repositoryProvider).updateArticle(hasReadArticle);
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
    ref.read(repositoryProvider).updateArticle(toggledArticle);
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
    ref.read(repositoryProvider).updateArticle(toggledArticle);
    return toggledArticle;
  }
}
