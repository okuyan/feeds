import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'feed.g.dart';

@immutable
@HiveType(typeId: 1)
class Feed extends Equatable {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final int articleCount;
  @HiveField(3)
  final DateTime lastBuildDate;

  const Feed(
      {required this.title,
      required this.url,
      required this.articleCount,
      required this.lastBuildDate});

  @override
  List<Object?> get props => [title, url, articleCount];

  Feed updateTitle(String title) {
    return Feed(
        title: title,
        url: url,
        articleCount: articleCount,
        lastBuildDate: lastBuildDate);
  }

  Feed updateUrl(String title) {
    return Feed(
        title: title,
        url: url,
        articleCount: articleCount,
        lastBuildDate: lastBuildDate);
  }

  Feed updateArticleCount(int count) {
    return Feed(
        title: title,
        url: url,
        articleCount: count,
        lastBuildDate: lastBuildDate);
  }
}
