import 'package:hive/hive.dart';

part 'article.g.dart';

//@immutable
@HiveType(typeId: 2)
class Article extends HiveObject {
  @HiveField(0)
  final String feedId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String link;
  @HiveField(3)
  final bool unread;
  @HiveField(4)
  final String? content;
  @HiveField(5)
  final DateTime? pubDate;
  @HiveField(6)
  final String? youTubeVideoId;
  @HiveField(7)
  final bool bookmarked;

  Article(
      {required this.feedId,
      required this.title,
      required this.link,
      required this.unread,
      required this.pubDate,
      this.content,
      this.youTubeVideoId,
      this.bookmarked = false});

  List<Object?> get props => [
        feedId,
        title,
        link,
        unread,
        content,
        pubDate,
        youTubeVideoId,
        bookmarked
      ];

  Article updateUnread(bool unread) {
    return Article(
        feedId: feedId,
        title: title,
        link: link,
        unread: unread,
        pubDate: pubDate,
        content: content,
        youTubeVideoId: youTubeVideoId,
        bookmarked: bookmarked);
  }

  Article updateBookmarked(bool bookmarked) {
    return Article(
        feedId: feedId,
        title: title,
        link: link,
        unread: unread,
        pubDate: pubDate,
        content: content,
        youTubeVideoId: youTubeVideoId,
        bookmarked: bookmarked);
  }
}
