import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'article.g.dart';

@immutable
@HiveType(typeId: 2)
class Article extends Equatable {
  @HiveField(0)
  final String siteUrl;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String link;
  @HiveField(3)
  final bool unread;
  @HiveField(4)
  final String? content;
  @HiveField(5)
  final DateTime pubDate;

  const Article({
    required this.siteUrl,
    required this.title,
    required this.link,
    required this.unread,
    this.content,
    required this.pubDate,
  });

  @override
  List<Object?> get props => [siteUrl, title, link, unread, content, pubDate];
}
