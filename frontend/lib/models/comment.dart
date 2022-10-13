// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    required this.success,
    required this.data,
  });

  bool success;
  List<CommentData> data;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        success: json["success"],
        data: List<CommentData>.from(
            json["data"].map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CommentData {
  CommentData({
    required this.id,
    required this.topicId,
    required this.commentDetail,
    required this.commentBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isCustomer,
    required this.image,
    required this.postName,
  });

  String id;
  String topicId;
  String commentDetail;
  String commentBy;
  DateTime createdAt;
  DateTime updatedAt;
  bool isCustomer;
  String image;
  PostName postName;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["_id"],
        topicId: json["topicId"],
        commentDetail: json["commentDetail"],
        commentBy: json["commentBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isCustomer: json["isCustomer"],
        image: json["image"],
        postName: PostName.fromJson(json["postName"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "topicId": topicId,
        "commentDetail": commentDetail,
        "commentBy": commentBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "isCustomer": isCustomer,
        "image": image,
        "postName": postName.toJson(),
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
