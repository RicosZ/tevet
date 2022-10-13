// To parse this JSON data, do
//
//     final topic = topicFromJson(jsonString);

import 'dart:convert';

Topic topicFromJson(String str) => Topic.fromJson(json.decode(str));

String topicToJson(Topic data) => json.encode(data.toJson());

class Topic {
  Topic({
    required this.success,
    required this.data,
  });

  bool success;
  TData data;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        success: json["success"],
        data: TData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class TData {
  TData({
    required this.id,
    required this.topicSubject,
    required this.topicBy,
    required this.topicDetail,
    required this.likes,
    required this.countViews,
    required this.countComment,
    required this.tags,
    required this.updatedAt,
    required this.createdAt,
    required this.isCustomer,
    required this.postName,
    required this.image,
    required this.countLike,
  });

  String id;
  String topicSubject;
  String topicBy;
  String topicDetail;
  List<String> likes;
  int countViews;
  int countComment;
  List<String> tags;
  DateTime updatedAt;
  DateTime createdAt;
  bool isCustomer;
  PostName postName;
  String image;
  int countLike;

  factory TData.fromJson(Map<String, dynamic> json) => TData(
        id: json["_id"],
        topicSubject: json["topicSubject"],
        topicBy: json["topicBy"],
        topicDetail: json["topicDetail"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        countViews: json["countViews"],
        countComment: json["countComment"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        isCustomer: json["isCustomer"],
        postName: PostName.fromJson(json["postName"]),
        image: json["image"],
        countLike: json["countLike"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "topicSubject": topicSubject,
        "topicBy": topicBy,
        "topicDetail": topicDetail,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "countViews": countViews,
        "countComment": countComment,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "isCustomer": isCustomer,
        "postName": postName.toJson(),
        "image": image,
        "countLike": countLike,
      };
}

class PostName {
  PostName({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory PostName.fromJson(Map<String, dynamic> json) => PostName(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
