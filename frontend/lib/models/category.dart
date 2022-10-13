// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
    Category({
        required this.success,
        required this.data,
    });

    bool success;
    List<CategoryData> data;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        success: json["success"],
        data: List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CategoryData {
    CategoryData({
        required this.id,
        required this.doctorId,
        required this.catName,
        required this.replyDcount,
        required this.replyDlast,
        required this.topicCount,
        required this.slug,
        required this.updatedAt,
    });

    String id;
    String doctorId;
    String catName;
    int replyDcount;
    DateTime replyDlast;
    int topicCount;
    String slug;
    DateTime updatedAt;

    factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["_id"],
        doctorId: json["doctorId"],
        catName: json["catName"],
        replyDcount: json["replyDcount"],
        replyDlast: DateTime.parse(json["replyDlast"]),
        topicCount: json["topicCount"],
        slug: json["slug"],
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "doctorId": doctorId,
        "catName": catName,
        "replyDcount": replyDcount,
        "replyDlast": replyDlast.toIso8601String(),
        "topicCount": topicCount,
        "slug": slug,
        "updatedAt": updatedAt.toIso8601String(),
    };
}
