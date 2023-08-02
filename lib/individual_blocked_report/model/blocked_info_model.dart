
class BlockInfoModel {
  int? status;
  String? message;
  List<Data>? data;

  BlockInfoModel({this.status, this.message, this.data});

  BlockInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? individualId;
  String? viewStatus;
  String? username;
  dynamic profilePicture;
  String? date;
  Data(
      {this.id,
        this.userId,
        this.individualId,
        this.viewStatus,
        this.username,
        this.profilePicture,
        this.date
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    individualId = json['individual_id'];
    viewStatus = json['view_status'];
    username = json['username'];
    profilePicture = json['profile_picture'];
    date =json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['individual_id'] = this.individualId;
    data['view_status'] = this.viewStatus;
    data['username'] = this.username;
    data['profile_picture'] = this.profilePicture;
    data['date'] = this.date;
    return data;
  }
}