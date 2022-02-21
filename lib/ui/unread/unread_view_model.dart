import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final unreadProvider = StateNotifierProvider<UnreadList, List<Article>>((ref) {
  final bookmarks = ref
      .read(repositoryProvider)
      .getArticles()
      .where((element) => element.unread == true)
      .toList();
  return UnreadList(ref: ref, initialArticles: bookmarks);
});

class UnreadList extends StateNotifier<List<Article>> {
  UnreadList({required this.ref, List<Article>? initialArticles})
      : super(initialArticles ?? []);

  final Ref ref;

  void getUnread() {
    final unread = ref
        .read(repositoryProvider)
        .getArticles()
        .toList()
        .where((element) => element.unread == true);
    state = [...unread];
  }
}
