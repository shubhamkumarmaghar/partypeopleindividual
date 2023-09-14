class UserModel {
  final String id;
  final dynamic fullName;
  final String username;
  final dynamic city;
  final String phone;
  final String profilePicture;
  final String onlineStatus;
   String likeStatus;
  final dynamic gender;
  final String privacyOnline;
  final String profilePicApproval;

  UserModel(
      {required this.id,
      required this.fullName,
      required this.username,
      required this.city,
      required this.phone,
      required this.profilePicture,
      required this.onlineStatus,
      required this.likeStatus,
      required this.gender,
      required this.privacyOnline,
      required this.profilePicApproval});

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
      gender: json['gender'],
      privacyOnline: json['privacy_online'],
      profilePicApproval: json['profile_pic_approval_status']
    );
  }
}
