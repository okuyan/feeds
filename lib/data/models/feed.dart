import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'feed.g.dart';

@HiveType(typeId: 1)
class Feed extends Equatable {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final int articleCount;

  const Feed(
      {required this.title, required this.url, required this.articleCount});

  @override
  List<Object?> get props => [title, url, articleCount];

  Feed updateTitle(String title) {
    return Feed(title: title, url: url, articleCount: articleCount);
  }

  Feed updateUrl(String title) {
    return Feed(title: title, url: url, articleCount: articleCount);
  }

  Feed updateArticleCount(int count) {
    return Feed(title: title, url: url, articleCount: count);
  }
}
