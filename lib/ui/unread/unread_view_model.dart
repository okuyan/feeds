import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feeds/data/models/models.dart';
import 'package:feeds/data/repository.dart';

final unreadProvider = StateNotifierProvider<UnreadList, List<Article>>((ref) {
  final unreadArticles = ref
      .watch(repositoryProvider)
      .getArticles()
      .where((element) => element.unread == true)
      .toList();
  unreadArticles.sort((b, a) {
    if (b.pubDate is DateTime && a.pubDate is DateTime) {
      return a.pubDate!.compareTo(b.pubDate as DateTime);
    } else {
      return 0;
    }
  });
  return UnreadList(ref: ref, initialArticles: unreadArticles);
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
        .where((element) => element.unread == true)
        .toList();

    unread.sort((b, a) {
      if (b.pubDate is DateTime && a.pubDate is DateTime) {
        return a.pubDate!.compareTo(b.pubDate as DateTime);
      } else {
        return 0;
      }
    });
    state = [...unread];
  }
}
