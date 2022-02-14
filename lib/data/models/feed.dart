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
  final String feedId;
  @HiveField(2)
  final int articleCount;
  @HiveField(3)
  final String website;

  const Feed(
      {required this.title,
      required this.feedId,
      required this.articleCount,
      required this.website});

  @override
  List<Object?> get props => [title, feedId, articleCount, website];

  Feed updateTitle(String title) {
    return Feed(
        title: title,
        feedId: feedId,
        articleCount: articleCount,
        website: website);
  }

  Feed updateUrl(String title) {
    return Feed(
        title: title,
        feedId: feedId,
        articleCount: articleCount,
        website: website);
  }

  Feed updateArticleCount(int count) {
    return Feed(
        title: title, feedId: feedId, articleCount: count, website: website);
  }
}
