// class UserModel {
//   final int id;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String avatar;

//   const UserModel({
//     required this.id,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.avatar,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         id: json['id'],
//         email: json['email'],
//         firstName: json['first_name'],
//         lastName: json['last_name'],
//         avatar: json['avatar'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'email': email,
//         'first_name': firstName,
//         'last_name': lastName,
//         'avatar': avatar,
//       };
// }



// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final int? page;
    final int? perPage;
    final int? total;
    final int? totalPages;
    final List<User>? data;
    final Support? support;

    UserModel({
        this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
        this.support,
    });

    UserModel copyWith({
        int? page,
        int? perPage,
        int? total,
        int? totalPages,
        List<User>? data,
        Support? support,
    }) => 
        UserModel(
            page: page ?? this.page,
            perPage: perPage ?? this.perPage,
            total: total ?? this.total,
            totalPages: totalPages ?? this.totalPages,
            data: data ?? this.data,
            support: support ?? this.support,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        data: json["data"] == null ? [] : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
        support: json["support"] == null ? null : Support.fromJson(json["support"]),
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "support": support?.toJson(),
    };
}

class User {
    final int? id;
    final String? email;
    final String? firstName;
    final String? lastName;
    final String? avatar;

    User({
        this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.avatar,
    });

    User copyWith({
        int? id,
        String? email,
        String? firstName,
        String? lastName,
        String? avatar,
    }) => 
        User(
            id: id ?? this.id,
            email: email ?? this.email,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            avatar: avatar ?? this.avatar,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
}

class Support {
    final String? url;
    final String? text;

    Support({
        this.url,
        this.text,
    });

    Support copyWith({
        String? url,
        String? text,
    }) => 
        Support(
            url: url ?? this.url,
            text: text ?? this.text,
        );

    factory Support.fromJson(Map<String, dynamic> json) => Support(
        url: json["url"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "text": text,
    };
}
