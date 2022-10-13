// To parse this JSON data, do
//
//     final categoryList = categoryListFromJson(jsonString);

import 'dart:convert';

CategoryList categoryListFromJson(String str) => CategoryList.fromJson(json.decode(str));

String categoryListToJson(CategoryList data) => json.encode(data.toJson());

class CategoryList {
    CategoryList({
        required this.success,
        required this.categories,
    });

    bool success;
    List<CategoryListData> categories;

    factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        success: json["success"],
        categories: List<CategoryListData>.from(json["categories"].map((x) => CategoryListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}

class CategoryListData {
    CategoryListData({
        required this.id,
        required this.catName,
        required this.slug,
    });

    String id;
    String catName;
    String slug;

    factory CategoryListData.fromJson(Map<String, dynamic> json) => CategoryListData(
        id: json["_id"],
        catName: json["catName"],
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "catName": catName,
        "slug": slug,
    };
}
