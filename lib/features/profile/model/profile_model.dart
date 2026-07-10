class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.email,
    this.name,
    this.bio,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? name;
  final String? bio;
  final String? avatarUrl;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'bio': bio,
      'avatar_url': avatarUrl,
    };
  }

  ProfileModel copyWith({
    String? name,
    String? bio,
    String? avatarUrl,
  }) {
    return ProfileModel(
      id: id,
      email: email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
