class GetUserModel {
  GetUserModel({
     this.status,
     this.message,
     this.data,
  });
   int? status;
   String? message;
   Data? data;

  GetUserModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.uniqueId,
    required this.socialId,
    required this.type,
    required this.ipAddress,
    required this.roleId,
    required this.username,
    required this.password,
    required this.email,
    required this.salt,
    required this.activationSelector,
    required this.activationCode,
    required this.forgottenPasswordSelector,
    required this.forgottenPasswordCode,
    required this.forgottenPasswordTime,
    required this.rememberSelector,
    required this.rememberCode,
    required this.createdOn,
    required this.registerDate,
    required this.lastLogin,
    required this.active,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.genderId,
    required this.cityId,
    required this.phone,
    required this.countryCode,
    required this.isVerifiedPhone,
    required this.latitude,
    required this.longitude,
    required this.isDeleted,
    required this.isSuspended,
    required this.profilePicture,
    required this.firstTime,
    required this.deviceToken,
    required this.otp,
    required this.otpExpiryDate,
    required this.userType,
    required this.onlineStatus,
    required this.privacyOnline,
    required this.notification,
    required this.onlineTimeExpiry,
    required this.fromBlockStatus,
    required this.profilePicApprovalStatus,

  });
  String? id;
  String? uniqueId;
  dynamic socialId;
  String? type;
  dynamic ipAddress;
  String? roleId;
  String? username;
  String? password;
  dynamic email;
  dynamic salt;
  dynamic activationSelector;
  dynamic activationCode;
  dynamic forgottenPasswordSelector;
  dynamic forgottenPasswordCode;
  dynamic forgottenPasswordTime;
  dynamic rememberSelector;
  dynamic rememberCode;
  String? createdOn;
  String? registerDate;
  String? lastLogin;
  String? active;
  dynamic firstName;
  dynamic lastName;
  dynamic dob;
  dynamic genderId;
  dynamic cityId;
  String? phone;
  dynamic countryCode;
  String? isVerifiedPhone;
  String? latitude;
  String? longitude;
  String? isDeleted;
  String? isSuspended;
  String? profilePicture;
  String? firstTime;
  String? deviceToken;
  String? otp;
  String? otpExpiryDate;
  dynamic userType;
  String? onlineStatus;
  String? privacyOnline;
  String? notification;
  dynamic onlineTimeExpiry;
  String? chatUserAvailableStatus;
  String? fromBlockStatus;
  String? gender;
  String? profilePicApprovalStatus;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    uniqueId = json['unique_id'];
    socialId = json['social_id'];
    type = json['type'];
    ipAddress = json['ip_address'];
    roleId = json['role_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    salt = json['salt'];
    activationSelector = json['activation_selector'];
    activationCode = json['activation_code'];
    forgottenPasswordSelector = json['forgotten_password_selector'];
    forgottenPasswordCode = json['forgotten_password_code'];
    forgottenPasswordTime = json['forgotten_password_time'];
    rememberSelector = json['remember_selector'];
    rememberCode = json['remember_code'];
    createdOn = json['created_on'];
    registerDate = json['register_date'];
    lastLogin = json['last_login'];
    active = json['active'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    genderId = json['gender_id'];
    cityId = json['city_id'];
    phone = json['phone'];
    countryCode = json['country_code'];
    isVerifiedPhone = json['is_verified_phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDeleted = json['is_deleted'];
    isSuspended = json['is_suspended'];
    profilePicture = json['profile_pic'];
    firstTime = json['first_time'];
    deviceToken = json['device_token'];
    otp = json['otp'];
    otpExpiryDate = json['otp_expiry_date'];
    userType = json['user_type'];
    onlineStatus = json['online_status'];
    privacyOnline = json['privacy_online'];
    notification = json['notification'];
    onlineTimeExpiry = json['online_time_expiry'];
    chatUserAvailableStatus = json['chat_user_available_status'];
    fromBlockStatus=json['from_block_status'];
    gender = json['gender'];
    profilePicApprovalStatus = json['profile_pic_approval_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['unique_id'] = uniqueId;
    _data['social_id'] = socialId;
    _data['type'] = type;
    _data['ip_address'] = ipAddress;
    _data['role_id'] = roleId;
    _data['username'] = username;
    _data['password'] = password;
    _data['email'] = email;
    _data['salt'] = salt;
    _data['activation_selector'] = activationSelector;
    _data['activation_code'] = activationCode;
    _data['forgotten_password_selector'] = forgottenPasswordSelector;
    _data['forgotten_password_code'] = forgottenPasswordCode;
    _data['forgotten_password_time'] = forgottenPasswordTime;
    _data['remember_selector'] = rememberSelector;
    _data['remember_code'] = rememberCode;
    _data['created_on'] = createdOn;
    _data['register_date'] = registerDate;
    _data['last_login'] = lastLogin;
    _data['active'] = active;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['dob'] = dob;
    _data['gender_id'] = genderId;
    _data['city_id'] = cityId;
    _data['phone'] = phone;
    _data['country_code'] = countryCode;
    _data['is_verified_phone'] = isVerifiedPhone;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['is_deleted'] = isDeleted;
    _data['is_suspended'] = isSuspended;
    _data['profile_picture'] = profilePicture;
    _data['first_time'] = firstTime;
    _data['device_token'] = deviceToken;
    _data['otp'] = otp;
    _data['otp_expiry_date'] = otpExpiryDate;
    _data['user_type'] = userType;
    _data['online_status'] = onlineStatus;
    _data['privacy_online'] = privacyOnline;
    _data['notification'] = notification;
    _data['online_time_expiry'] = onlineTimeExpiry;
    _data['chat_user_available_status'] = chatUserAvailableStatus;
    _data['from_block_status']=fromBlockStatus;
    _data['gender']=gender;
    _data['profile_pic_approval_status'] = profilePicApprovalStatus;
    return _data;
  }
}