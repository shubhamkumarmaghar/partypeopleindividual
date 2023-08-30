class SubscriptionModel {
  SubscriptionModel({
     this.status,
     this.message,
     required this.subsData,
  });
    int? status;
    String? message;
    List<SubscriptionData> subsData = [];

  SubscriptionModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    subsData = List.from(json['data']).map((e)=>SubscriptionData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = subsData.map((e)=>e.toJson()).toList();
    return _data;
  }

}

class SubscriptionData {
  SubscriptionData({
    required this.id,
    required this.name,
    required this.description,
    required this.day,
    required this.amount,
    required this.status,
  });
  late final String id;
  late final String name;
  late final String description;
  late final String day;
  late final String amount;
  late final String status;

  SubscriptionData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    day = json['day'];
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['day'] = day;
    _data['amount'] = amount;
    _data['status'] = status;
    return _data;
  }
}