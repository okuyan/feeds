import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final bookmarksProvider =
    StateNotifierProvider<BookmakedList, List<Article>>((ref) {
  final bookmarks = ref
      .watch(repositoryProvider)
      .getArticles()
      .where((element) => element.bookmarked == true)
      .toList();
  return BookmakedList(ref: ref, initialArticles: bookmarks);
});

class BookmakedList extends StateNotifier<List<Article>> {
  BookmakedList({required this.ref, List<Article>? initialArticles})
      : super(initialArticles ?? []);

  final Ref ref;

  void getBookmarks() {
    final bookmarks = ref
        .read(repositoryProvider)
        .getArticles()
        .toList()
        .where((element) => element.bookmarked == true);
    state = [...bookmarks];
  }
}
