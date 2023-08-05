class OrganizationDetailsModel {
  OrganizationDetailsModel({
     this.status,
     this.message,
     this.notificationCount,
     this.userPhoneNumber,
     this.privacyOnline,
     this.notification,
     this.userName,
     this.data,
  });
  late final int? status;
  late final String? message;
  late final int? notificationCount;
  late final String? userPhoneNumber;
  late final String? privacyOnline;
  late final String? notification;
  late final String? userName;
  late final List<Data?>? data;

  OrganizationDetailsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    notificationCount = json['notification_count'];
    userPhoneNumber = json['user_phone_number'];
    privacyOnline = json['privacy_online'];
    notification = json['notification'];
    userName = json['user_name'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['notification_count'] = notificationCount;
    _data['user_phone_number'] = userPhoneNumber;
    _data['privacy_online'] = privacyOnline;
    _data['notification'] = notification;
    _data['user_name'] = userName;
    _data['data'] = data?.map((e)=>e?.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
     this.id,
     this.userId,
     this.cityId,
     this.name,
     this.email,
     this.displayName,
     this.description,
     this.branch,
     this.latitude,
     this.longitude,
     this.type,
     this.createdAt,
     this.updatedAt,
     this.like,
     this.view,
     this.ongoing,
     this.rating,
     this.orgAmenitieId,
     this.profilePic,
     this.timelinePic,
     this.profilePicApprovalStatus,
     this.approvalStatus,
     this.bluetickStatus,
     this.isDeleted,
     this.gender,
     this.bio,
     this.dob,
     this.pincode,
     this.occupation,
     this.qualification,
     this.country,
     this.state,
     this.city,
     this.coverPhoto,
     this.status,
     this.displayStatus,
     this.organizationAmenities,
  });
  late final String? id;
  late final String? userId;
  late final String? cityId;
  late final String? name;
  late final dynamic email;
  late final String? displayName;
  late final String? description;
  late final String? branch;
  late final String? latitude;
  late final String? longitude;
  late final String? type;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? like;
  late final String? view;
  late final String? ongoing;
  late final String? rating;
  late final String? orgAmenitieId;
  late final String? profilePic;
  late final String? timelinePic;
  late final String? profilePicApprovalStatus;
  late final String? approvalStatus;
  late final String? bluetickStatus;
  late final String? isDeleted;
  late final dynamic gender;
  late final dynamic bio;
  late final dynamic dob;
  late final dynamic pincode;
  late final dynamic occupation;
  late final dynamic qualification;
  late final dynamic country;
  late final dynamic state;
  late final dynamic city;
  late final dynamic coverPhoto;
  late final dynamic status;
  late final String? displayStatus;
  late final List<OrganizationAmenities?>? organizationAmenities;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    cityId = json['city_id'];
    name = json['name'];
    email = json['email'];
    displayName = json['display_name'];
    description = json['description'];
    branch = json['branch'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    like = json['like'];
    view = json['view'];
    ongoing = json['ongoing'];
    rating = json['rating'];
    orgAmenitieId = json['org_amenitie_id'];
    profilePic = json['profile_pic'];
    timelinePic = json['timeline_pic'];
    profilePicApprovalStatus = json['profile_pic_approval_status'];
    approvalStatus = json['approval_status'];
    bluetickStatus = json['bluetick_status'];
    isDeleted = json['is_deleted'];
    gender = json['gender'];
    bio = json['bio'];
    dob = json['dob'];
    pincode = json['pincode'];
    occupation = json['occupation'];
    qualification = json['qualification'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    coverPhoto = json['coverPhoto'];
    status = json['status'];
    displayStatus = json['display_status'];
    organizationAmenities = List.from(json['organization_amenities']).map((e)=>OrganizationAmenities.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['city_id'] = cityId;
    _data['name'] = name;
    _data['email'] = email;
    _data['display_name'] = displayName;
    _data['description'] = description;
    _data['branch'] = branch;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['type'] = type;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['like'] = like;
    _data['view'] = view;
    _data['ongoing'] = ongoing;
    _data['rating'] = rating;
    _data['org_amenitie_id'] = orgAmenitieId;
    _data['profile_pic'] = profilePic;
    _data['timeline_pic'] = timelinePic;
    _data['profile_pic_approval_status'] = profilePicApprovalStatus;
    _data['approval_status'] = approvalStatus;
    _data['bluetick_status'] = bluetickStatus;
    _data['is_deleted'] = isDeleted;
    _data['gender'] = gender;
    _data['bio'] = bio;
    _data['dob'] = dob;
    _data['pincode'] = pincode;
    _data['occupation'] = occupation;
    _data['qualification'] = qualification;
    _data['country'] = country;
    _data['state'] = state;
    _data['city'] = city;
    _data['cover_photo'] = coverPhoto;
    _data['status'] = status;
    _data['display_status'] = displayStatus;
    _data['organization_amenities'] = organizationAmenities?.map((e)=>e?.toJson()).toList();
    return _data;
  }
}

class OrganizationAmenities {
  OrganizationAmenities({
    this.id,
    this.orgCatId,
    this.name,
    this.type,
  });
  late final String? id;
  late final String? orgCatId;
  late final String? name;
  late final String? type;

  OrganizationAmenities.fromJson(Map<String, dynamic> json){
    id = json['id'];
    orgCatId = json['org_cat_id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['org_cat_id'] = orgCatId;
    _data['name'] = name;
    _data['type'] = type;
    return _data;
  }
}