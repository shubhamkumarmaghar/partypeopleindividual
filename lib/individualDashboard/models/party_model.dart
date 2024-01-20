class Party {
  final String id;
  final String userId;
  final String userType;
  final String phoneNumber;
  final String organizationId;
  final String title;
  final String others;
  final String description;
  final String coverPhoto;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String prStartDate;
  final String prEndDate;
  final String latitude;
  final String longitude;
  final String type;
  final String gender;
  final String startAge;
  final String endAge;
  final String personLimit;
  final String status;
  final String active;
  final String createdAt;
  final String updatedAt;
  final String isDeleted;
  final String like;
  final String view;
  final String ongoing;
  final String offers;
  final String ladies;
  final String stag;
  final String couples;
  final String papularStatus;
  final String papularTime;
  final String subscriotionType;
  final String partyAmenitieId;
  final String imageStatus;
  final String approvalStatus;
  final String organization;
  final String fullName;
  final String profilePicture;
  final List<PartyAmenitie> partyAmenities;
  final String orgRatings;
  final String orgBluetickStatus;
  final int ongoingStatus;
  final int likeStatus;
  final String pincode;
  final dynamic sharePartyUrl;
  String? imageB;
  String? imageC;
  String? discountType;
  String?  discountAmount;
  String?  billMaxAmount;
  String?  discountDescription;



  Party({
    required this.id,
    required this.userId,
    required this.userType,
    required this.phoneNumber,
    required this.organizationId,
    required this.title,
    required this.others,
    required this.description,
    required this.coverPhoto,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.prStartDate,
    required this.prEndDate,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.gender,
    required this.startAge,
    required this.endAge,
    required this.personLimit,
    required this.status,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.like,
    required this.view,
    required this.ongoing,
    required this.offers,
    required this.ladies,
    required this.stag,
    required this.couples,
    required this.papularStatus,
    required this.papularTime,
    required this.subscriotionType,
    required this.partyAmenitieId,
    required this.imageStatus,
    required this.approvalStatus,
    required this.organization,
    required this.fullName,
    required this.profilePicture,
    required this.partyAmenities,
    required this.orgRatings,
    required this.orgBluetickStatus,
    required this.ongoingStatus,
    required this.likeStatus,
    required this.pincode,
    required this.sharePartyUrl,
    this.imageB,
    this.imageC,
    this.discountDescription,
    this.discountAmount,
    this.billMaxAmount,
    this.discountType
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['organization_id'] = this.organizationId;
    data['title'] = this.title;
    data['others'] = this.others;
    data['description'] = this.description;
    data['cover_photo'] = this.coverPhoto;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['pr_start_date'] = this.prStartDate;
    data['pr_end_date'] = this.prEndDate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['type'] = this.type;
    data['gender'] = this.gender;
    data['start_age'] = this.startAge;
    data['end_age'] = this.endAge;
    data['person_limit'] = this.personLimit;
    data['status'] = this.status;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_deleted'] = this.isDeleted;
    data['like'] = this.like;
    data['view'] = this.view;
    data['ongoing'] = this.ongoing;
    data['offers'] = this.offers;
    data['ladies'] = this.ladies;
    data['stag'] = this.stag;
    data['couples'] = this.couples;
    data['papular_status'] = this.papularStatus;
    data['papular_time'] = this.papularTime;
    data['subscriotion_type'] = this.subscriotionType;
    data['party_amenitie_id'] = this.partyAmenitieId;
    data['image_status'] = this.imageStatus;
    data['approval_status'] = this.approvalStatus;
    data['organization'] = this.organization;
    data['full_name'] = this.fullName;
    data['profile_picture'] = this.profilePicture;
    data['org_ratings'] = this.profilePicture;
    data['org_bluetick_status'] = this.profilePicture;
    data['ongoing_status'] = this.ongoingStatus;
    data['like_status'] = this.likeStatus;
    data['pincode'] =this.pincode;
    data['image_b'] = this.imageB;
    data['image_c'] = this.imageC;
    data['share_party_url']=this.sharePartyUrl;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['bill_amount'] = this.billMaxAmount;
    data['discount_description'] = this.discountDescription;

    if (this.partyAmenities != null) {
      data['party_amenitie'] =
          this.partyAmenities.map((v) => v.toJson()).toList();
    }
    return data;
  }


  factory Party.fromJson(Map<String, dynamic> json) {
    var partyAmenitieFromJson = json['party_amenitie'] as List;
    List<PartyAmenitie> partyAmenitieList =
        partyAmenitieFromJson.map((i) => PartyAmenitie.fromJson(i)).toList();

    return Party(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userType: json['user_type'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      organizationId: json['organization_id'] ?? '',
      title: json['title'] ?? '',
      others: json['others'] ?? '',
      description: json['description'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      prStartDate: json['pr_start_date'] ?? '',
      prEndDate: json['pr_end_date'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      startAge: json['start_age'] ?? '',
      endAge: json['end_age'] ?? '',
      personLimit: json['person_limit'] ?? '',
      status: json['status'] ?? '',
      active: json['active'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isDeleted: json['is_deleted'] ?? '',
      like: json['like'] ?? '',
      view: json['view'] ?? '',
      ongoing: json['ongoing'] ?? '',
      offers: json['offers'] ?? '',
      ladies: json['ladies'] ?? '',
      stag: json['stag'] ?? '',
      couples: json['couples'] ?? '',
      papularStatus: json['papular_status'] ?? '',
      papularTime: json['papular_time'] ?? '',
      subscriotionType: json['subscriotion_type'] ?? '',
      partyAmenitieId: json['party_amenitie_id'] ?? '',
      imageStatus: json['image_status'] ?? '',
      approvalStatus: json['approval_status'] ?? '',
      organization: json['organization'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      orgRatings: json['org_ratings'] ?? '',
      orgBluetickStatus: json['org_bluetick_status'] ?? '',
      ongoingStatus: json['ongoing_status'],
      likeStatus: json['like_status'],
      pincode: json['pincode'],
      imageB : json['image_b'],
      imageC : json['image_c'],
      sharePartyUrl: json['share_party_url'],
      discountAmount: json['discount_amount'],
      discountDescription: json['discount_description'],
      discountType: json['discount_type'],
      billMaxAmount: json['bill_amount'],
      partyAmenities: partyAmenitieList,
    );
  }
}

class PartyAmenitie {
  final String id;
  final String name;

  PartyAmenitie({
    required this.id,
    required this.name,
  });

  factory PartyAmenitie.fromJson(Map<String, dynamic> json) {
    return PartyAmenitie(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
