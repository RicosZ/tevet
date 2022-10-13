// To parse this JSON data, do
//
//     final topic = topicFromJson(jsonString);

import 'dart:convert';

Topics topicFromJson(String str) => Topics.fromJson(json.decode(str));

String topicToJson(Topics data) => json.encode(data.toJson());

class Topics {
  Topics({
    required this.success,
    required this.data,
  });

  bool success;
  List<TopicData> data;

  factory Topics.fromJson(Map<String, dynamic> json) => Topics(
        success: json["success"],
        data: List<TopicData>.from(json["data"].map((x) => TopicData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TopicData {
  TopicData({
    required this.id,
    required this.topicSubject,
    required this.slugId,
    required this.topicDetail,
    required this.topicBy,
    required this.countViews,
    required this.countComment,
    required this.tags,
    required this.createdAt,
    required this.countLike,
  });

  String id;
  String topicSubject;
  int slugId;
  String topicDetail;
  TopicBy topicBy;
  int countViews;
  int countComment;
  List<String> tags;
  DateTime createdAt;
  int countLike;

  factory TopicData.fromJson(Map<String, dynamic> json) => TopicData(
        id: json["_id"],
        topicSubject: json["topicSubject"],
        slugId: json["slugId"],
        topicDetail: json["topicDetail"],
        topicBy: TopicBy.fromJson(json["topicBy"]),
        countViews: json["countViews"],
        countComment: json["countComment"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        countLike: json["countLike"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "topicSubject": topicSubject,
        "slugId": slugId,
        "topicDetail": topicDetail,
        "topicBy": topicBy.toJson(),
        "countViews": countViews,
        "countComment": countComment,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "countLike": countLike,
      };
}

class TopicBy {
  TopicBy({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory TopicBy.fromJson(Map<String, dynamic> json) => TopicBy(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
