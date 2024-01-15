class GetVersion {
  int? status;
  String? message;
  Data? data;

  GetVersion({this.status, this.message, this.data});

  GetVersion.fromJson(Map<String, dynamic> json) {
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
  String? osType;
  String? version;
  String? forcefullyUpdate;
  String? nUpdateMsg;
  String? ffUpdateMsg;

  Data(
      {this.id,
        this.osType,
        this.version,
        this.forcefullyUpdate,
        this.nUpdateMsg,
        this.ffUpdateMsg});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    osType = json['os_type'];
    version = json['version'];
    forcefullyUpdate = json['forcefully_update'];
    nUpdateMsg = json['n_update_msg'];
    ffUpdateMsg = json['ff_update_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['os_type'] = this.osType;
    data['version'] = this.version;
    data['forcefully_update'] = this.forcefullyUpdate;
    data['n_update_msg'] = this.nUpdateMsg;
    data['ff_update_msg'] = this.ffUpdateMsg;
    return data;
  }
}