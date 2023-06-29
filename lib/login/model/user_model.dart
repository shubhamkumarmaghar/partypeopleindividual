class User {
  final int userId;
  final String email;
  final String fullName;
  final String countryCode;
  final String profilePicture;
  final String phone;
  final bool isVerifiedPhone;
  final bool firstTime;
  final String? otp;
  final String uniqueId;
  final String token;

  User({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.countryCode,
    required this.profilePicture,
    required this.phone,
    required this.isVerifiedPhone,
    required this.firstTime,
    required this.otp,
    required this.uniqueId,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      countryCode: json['country_code'] as String,
      profilePicture: json['profile_picture'] as String,
      phone: json['phone'] as String,
      isVerifiedPhone: (json['is_verified_phone'] as int) == 1,
      firstTime: (json['first_time'] as int) == 1,
      otp: json['otp'] as String?,
      uniqueId: json['unique_id'] as String,
      token: json['token'] as String,
    );
  }
}
