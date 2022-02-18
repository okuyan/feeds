import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final bookmarksProvider =
    StateNotifierProvider<BookmakedList, List<Article>>((ref) {
  final bookmarks = ref
      .read(repositoryProvider)
      .getArticles()
      .where((element) => element.bookmarked == true)
      .toList();
  return BookmakedList(
      repository: ref.read(repositoryProvider), initialArticles: bookmarks);
});

class BookmakedList extends StateNotifier<List<Article>> {
  BookmakedList({required this.repository, List<Article>? initialArticles})
      : super(initialArticles ?? []);

  final Repository repository;

  void getBookmarks() {
    final bookmarks = repository
        .getArticles()
        .toList()
        .where((element) => element.bookmarked == true);
    state = [...bookmarks];
  }
}
