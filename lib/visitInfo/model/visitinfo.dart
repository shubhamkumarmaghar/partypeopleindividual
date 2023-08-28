
class VisitInfoModel {
  int? status;
  String? message;
  List<VisiterInfoData>? data;

  VisitInfoModel({this.status, this.message, this.data});

  VisitInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VisiterInfoData>[];
      json['data'].forEach((v) {
        data!.add(new VisiterInfoData.fromJson(v));
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

class VisiterInfoData {
  String? id;
  String? userId;
  String? individualId;
  String? viewStatus;
  String? username;
  dynamic profilePicture;
  String? likeunlike;
  String? date;
  VisiterInfoData(
      {this.id,
        this.userId,
        this.individualId,
        this.viewStatus,
        this.username,
        this.profilePicture,
      this.likeunlike,
      this.date});

  VisiterInfoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    individualId = json['individual_id'];
    viewStatus = json['view_status'];
    username = json['username'];
    profilePicture = json['profile_picture'];
    likeunlike = json["like_unlike"];
    date = json["date"];
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