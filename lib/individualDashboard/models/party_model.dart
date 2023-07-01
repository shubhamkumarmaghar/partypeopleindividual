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

class Party {
  final String id;
  final String title;
  final String description;
  final String coverPhoto;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String latitude;
  final String longitude;
  final String offers;
  final String organization;
  final String fullName;
  final List<PartyAmenitie> partyAmenitie;

  Party({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPhoto,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.latitude,
    required this.longitude,
    required this.offers,
    required this.organization,
    required this.fullName,
    required this.partyAmenitie,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    var partyAmenitieFromJson = json['party_amenitie'] as List;
    List<PartyAmenitie> partyAmenitieList =
        partyAmenitieFromJson.map((i) => PartyAmenitie.fromJson(i)).toList();

    return Party(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverPhoto: json['cover_photo'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      offers: json['offers'],
      organization: json['organization'],
      fullName: json['full_name'],
      partyAmenitie: partyAmenitieList,
    );
  }
}
