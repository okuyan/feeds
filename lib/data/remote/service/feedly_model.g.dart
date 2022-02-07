// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedly_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedlyResults _$FeedlyResultsFromJson(Map<String, dynamic> json) =>
    FeedlyResults(
      results: (json['results'] as List<dynamic>)
          .map((e) => FeedlyResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedlyResultsToJson(FeedlyResults instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

FeedlyResult _$FeedlyResultFromJson(Map<String, dynamic> json) => FeedlyResult(
      title: json['title'] as String,
      website: json['website'] as String,
      feedId: _parseFeedId(json['feedId'] as String),
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$FeedlyResultToJson(FeedlyResult instance) =>
    <String, dynamic>{
      'title': instance.title,
      'website': instance.website,
      'feedId': instance.feedId,
      'iconUrl': instance.iconUrl,
    };
