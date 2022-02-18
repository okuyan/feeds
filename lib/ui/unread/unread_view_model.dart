import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final unreadProvider = StateNotifierProvider<UnreadList, List<Article>>((ref) {
  final bookmarks = ref
      .read(repositoryProvider)
      .getArticles()
      .where((element) => element.unread == true)
      .toList();
  return UnreadList(
      repository: ref.read(repositoryProvider), initialArticles: bookmarks);
});

class UnreadList extends StateNotifier<List<Article>> {
  UnreadList({required this.repository, List<Article>? initialArticles})
      : super(initialArticles ?? []);

  final Repository repository;

  void getUnread() {
    final unread = repository
        .getArticles()
        .toList()
        .where((element) => element.unread == true);
    state = [...unread];
  }
}
