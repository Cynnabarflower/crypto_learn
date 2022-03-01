import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class User {
  String? id;
  String? uid;
  bool get auth => (id??'').isNotEmpty;
  bool premium = false;
  bool get admin => role == types.Role.admin;
  bool get moderator => role == types.Role.moderator;
  bool get moderatorOrAdmin => role == types.Role.moderator || role == types.Role.admin;
  String get name => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  String? token;
  String? email;
  int? createdAt;
  String? firstName;
  String? imageUrl;
  String? lastName;
  int? lastSeen;
  Map<String, dynamic>? metadata;
  types.Role? role;
  int? updatedAt;


  User({this.id, this.uid, this.email, this.firstName, this.lastName, this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    token = json['token'];
    premium = json['premium'] ?? false;
    email = json['email'];

    createdAt = json['createdAt'] as int?;
    firstName = json['firstName'] as String?;
    id = (json['id'] ?? '') as String;
    imageUrl = json['imageUrl'] as String?;
    lastName = json['lastName'] as String?;
    lastSeen = json['lastSeen'] as int?;
    metadata = json['metadata'] as Map<String, dynamic>?;
    role = types.Role.values.fold(types.Role.user, (p, e) => e.name == json['role'] ? e : p);
    updatedAt = json['updatedAt'] as int?;
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    val['email'] = email;
    val['token'] = token;
    val['premium'] = premium;
    val['uid'] = uid;

    writeNotNull('createdAt', createdAt);
    writeNotNull('firstName', firstName);
    val['id'] = id;
    writeNotNull('imageUrl', imageUrl);
    writeNotNull('lastName', lastName);
    writeNotNull('lastSeen', lastSeen);
    writeNotNull('metadata', metadata);
    writeNotNull('role', role?.name);
    writeNotNull('updatedAt', updatedAt);
    return val;
  }

}