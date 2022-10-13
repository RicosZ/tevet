// To parse this JSON data, do
//
//     final tag = tagFromJson(jsonString);

import 'dart:convert';

Tag tagFromJson(String str) => Tag.fromJson(json.decode(str));

String tagToJson(Tag data) => json.encode(data.toJson());

class Tag {
    Tag({
        required this.success,
        required this.data,
    });

    bool success;
    List<TagData> data;

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        success: json["success"],
        data: List<TagData>.from(json["data"].map((x) => TagData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TagData {
    TagData({
        required this.id,
        required this.name,
    });

    String id;
    String name;

    factory TagData.fromJson(Map<String, dynamic> json) => TagData(
        id: json["_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
    };
}
