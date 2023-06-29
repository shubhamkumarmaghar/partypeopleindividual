class IndividualCity {
  final String id;
  final String name;
  final String imageUrl;

  IndividualCity(
      {required this.id, required this.name, required this.imageUrl});

  factory IndividualCity.fromJson(Map<String, dynamic> json) {
    return IndividualCity(
      id: json['id'].toString(),
      name: json['name'] as String,
      imageUrl: json['image'] as String,
    );
  }
}
