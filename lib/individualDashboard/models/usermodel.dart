class UserModel {
  final String id;
  final dynamic fullName;
  final String username;
  final dynamic city;
  final String phone;
  final String profilePicture;
  final String onlineStatus;
  final String likeStatus;
  final String gender;

  UserModel(
      {required this.id,
      required this.fullName,
      required this.username,
      required this.city,
      required this.phone,
      required this.profilePicture,
      required this.onlineStatus,
      required this.likeStatus,
      required this.gender});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      city: json['city'],
      phone: json['phone'],
      profilePicture: json['profile_picture'],
      onlineStatus: json['online_status'],
      likeStatus: json['like_status'],
      gender: json['gender']
    );
  }
}
