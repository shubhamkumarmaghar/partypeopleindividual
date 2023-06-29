class OTPVerificationResponse {
  int? status;
  String message;
  OTPVerificationData data;

  OTPVerificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OTPVerificationResponse(
      status: json['status'] as int?,
      message: json['message'],
      data: OTPVerificationData.fromJson(json['data']),
    );
  }
}

class OTPVerificationData {
  int? userId;
  String email;
  String fullName;
  String countryCode;
  String profilePicture;
  String phone;
  String isVerifiedPhone;
  int firstTime;
  String uniqueId;
  String? userType;
  String token;

  OTPVerificationData({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.countryCode,
    required this.profilePicture,
    required this.phone,
    required this.isVerifiedPhone,
    required this.firstTime,
    required this.uniqueId,
    required this.userType,
    required this.token,
  });

  factory OTPVerificationData.fromJson(Map<String, dynamic> json) {
    return OTPVerificationData(
      userId: json['user_id'] as int?,
      email: json['email'],
      fullName: json['full_name'],
      countryCode: json['country_code'],
      profilePicture: json['profile_picture'],
      phone: json['phone'],
      isVerifiedPhone: json['is_verified_phone'],
      firstTime: json['first_time'],
      uniqueId: json['unique_id'],
      userType: json['user_type'] as String?,
      token: json['token'],
    );
  }
}
