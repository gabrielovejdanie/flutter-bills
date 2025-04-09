class PBUser {
  final String id;
  final DateTime created;
  final DateTime updated;
  final String collectionId;
  final String collectionName;
  final Map<String, dynamic> expand;
  final String avatar;
  final String email;
  final bool emailVisibility;
  final String name;
  final bool verified;

  PBUser({
    required this.id,
    required this.created,
    required this.updated,
    required this.collectionId,
    required this.collectionName,
    required this.expand,
    required this.avatar,
    required this.email,
    required this.emailVisibility,
    required this.name,
    required this.verified,
  });

  factory PBUser.fromJson(json) {
    return PBUser(
      id: json['id'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      expand: json['expand'] ?? {},
      avatar: json['avatar'],
      email: json['email'],
      emailVisibility: json['emailVisibility'],
      name: json['name'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'collectionId': collectionId,
      'collectionName': collectionName,
      'expand': expand,
      'avatar': avatar,
      'email': email,
      'emailVisibility': emailVisibility,
      'name': name,
      'verified': verified,
    };
  }
}
