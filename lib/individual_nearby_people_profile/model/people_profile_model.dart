class PeopleProfileData {
  int? status;
  String? message;
  Data? data;

  PeopleProfileData({this.status, this.message, this.data});

  PeopleProfileData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? cityId;
  String? name;
  dynamic email;
  dynamic displayName;
  String? description;
  dynamic branch;
  String? latitude;
  String? longitude;
  String? type;
  String? createdAt;
  String? updatedAt;
  String? like;
  String? view;
  String? ongoing;
  String? rating;
  String? orgAmenitieId;
  String? profilePic;
  dynamic timelinePic;
  String? profilePicApprovalStatus;
  String? profilePicApprovalStatusE;
  String? profilePicApprovalStatusB;
  String? profilePicApprovalStatusC;
  String? profilePicApprovalStatusD;
  String? descriptionApprovalStatus;
  String? approvalStatus;
  String? bluetickStatus;
  String? isDeleted;
  String? gender;
  String? maritalStatus;
  String? bio;
  String? dob;
  String? pincode;
  String? occupation;
  String? qualification;
  String? country;
  String? state;
  String? city;
  String? coverPhoto;
  String? profileImageB;
  String? profileImageC;
  String? profileImageD;
  String? profileImageE;
  String? status;
  String? displayStatus;
  List<OrganizationAmenities>? organizationAmenities;
  String? fullName;
  String? phone;
  int? likeStatus;
  Data(
      {this.id,
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
        this.profileImageB,
        this.profileImageC,
        this.profileImageD,
        this.profileImageE,
        this.profilePicApprovalStatus,
        this.profilePicApprovalStatusB,
        this.profilePicApprovalStatusC,
        this.profilePicApprovalStatusD,
        this.profilePicApprovalStatusE,
        this.approvalStatus,
        this.bluetickStatus,
        this.isDeleted,
        this.gender,
        this.maritalStatus,
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
        this.fullName,
        this.phone,
      this.likeStatus,
      this.descriptionApprovalStatus});

  Data.fromJson(Map<String, dynamic> json) {
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
    profilePicApprovalStatusB = json['profile_pic_b_status'];
    profilePicApprovalStatusC = json['profile_pic_c_status'];
    profilePicApprovalStatusD = json['profile_pic_d_status'];
    profilePicApprovalStatusE = json['profile_pic_e_status'];
    approvalStatus = json['approval_status'];
    bluetickStatus = json['bluetick_status'];
    isDeleted = json['is_deleted'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    bio = json['bio'];
    dob = json['dob'];
    pincode = json['pincode'];
    occupation = json['occupation'];
    qualification = json['qualification'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    coverPhoto = json['cover_photo'];
    profileImageB = json['profile_pic_b'];
    profileImageC = json['profile_pic_c'];
    profileImageD = json['profile_pic_d'];
    profileImageE = json['profile_pic_e'];
    status = json['status'];
    displayStatus = json['display_status'];
    likeStatus = json['like_status'];
    descriptionApprovalStatus = json['approval_desciption_status'];
    if (json['organization_amenities'] != null) {
      organizationAmenities = <OrganizationAmenities>[];
      json['organization_amenities'].forEach((v) {
        organizationAmenities!.add(new OrganizationAmenities.fromJson(v));
      });
    }
    fullName = json['full_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['city_id'] = this.cityId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['display_name'] = this.displayName;
    data['description'] = this.description;
    data['branch'] = this.branch;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['like'] = this.like;
    data['view'] = this.view;
    data['ongoing'] = this.ongoing;
    data['rating'] = this.rating;
    data['org_amenitie_id'] = this.orgAmenitieId;
    data['profile_pic'] = this.profilePic;
    data['profile_pic_b'] = this.profilePic;
    data['profile_pic_c'] = this.profilePic;
    data['profile_pic_d'] = this.profilePic;
    data['profile_pic_e'] = this.profilePic;
    data['profile_pic_approval_status'] = this.profilePicApprovalStatus;
    data['approval_desciption_status'] = this.descriptionApprovalStatus;
    data['profile_pic_b_status'] = this.profilePicApprovalStatusB;
    data['profile_pic_c_status'] = this.profilePicApprovalStatusC;
    data['profile_pic_d_status'] = this.profilePicApprovalStatusD;
    data['profile_pic_e_status'] = this.profilePicApprovalStatusE;
    data['approval_status'] = this.approvalStatus;
    data['bluetick_status'] = this.bluetickStatus;
    data['is_deleted'] = this.isDeleted;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['bio'] = this.bio;
    data['dob'] = this.dob;
    data['pincode'] = this.pincode;
    data['occupation'] = this.occupation;
    data['qualification'] = this.qualification;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['cover_photo'] = this.coverPhoto;
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    if (this.organizationAmenities != null) {
      data['organization_amenities'] =
          this.organizationAmenities!.map((v) => v.toJson()).toList();
    }
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['like_status']= this.likeStatus;
    return data;
  }
}

class OrganizationAmenities {
  String? id;
  String? orgCatId;
  String? name;
  String? type;

  OrganizationAmenities({this.id, this.orgCatId, this.name, this.type});

  OrganizationAmenities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orgCatId = json['org_cat_id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['org_cat_id'] = this.orgCatId;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
