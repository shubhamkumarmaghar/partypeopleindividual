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
  });

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
}
