import 'package:json_annotation/json_annotation.dart';
import '../../models/models.dart';

part 'feedly_model.g.dart';

@JsonSerializable()
class FeedlyResults {
  List<FeedlyResult> results;

  FeedlyResults({
    required this.results,
  });

  factory FeedlyResults.fromJson(Map<String, dynamic> json) =>
      _$FeedlyResultsFromJson(json);

  Map<String, dynamic> toJson() => _$FeedlyResultsToJson(this);
}

@JsonSerializable()
class FeedlyResult {
  String title;
  String website;
  @JsonKey(fromJson: _parseFeedId)
  String feedId;
  String? iconUrl;

  FeedlyResult({
    required this.title,
    required this.website,
    required this.feedId,
    this.iconUrl,
  });

  factory FeedlyResult.fromJson(Map<String, dynamic> json) =>
      _$FeedlyResultFromJson(json);

  Map<String, dynamic> toJson() => _$FeedlyResultToJson(this);
}

// To remove "feed/"
String _parseFeedId(String feedId) => feedId.replaceRange(0, 5, '');
