class ChatUserListModel {
  ChatUserListModel({
    required this.id,
    required this.username,
    required this.onlineStatus,
    required this.createdAt,
    required this.profilePic,
    this.displayName,
    required this.displayStatus,
    required this.type,
    required this.blockStatus

  });
  late final dynamic id;
  late final dynamic username;
  late final dynamic onlineStatus;
  late final String createdAt;
  late final dynamic profilePic;
  late final dynamic displayName;
  late final dynamic displayStatus;
  late final String type;
  late final dynamic lastMessage;
  late final dynamic lastMessageTime;
  late final String blockStatus;


  ChatUserListModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    onlineStatus = json['online_status'];
    createdAt = json['created_at'];
    profilePic = json['profile_pic'];
    displayName = json['display_name'];
    displayStatus = json['display_status'];
    type = json['type'];
    lastMessage = json['message'];
    lastMessageTime = json['update_date'];
    blockStatus = json['block_status'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['online_status'] = onlineStatus;
    _data['created_at'] = createdAt;
    _data['profile_pic'] = profilePic;
    _data['display_name'] = displayName;
    _data['display_status'] = displayStatus;
    _data['type'] = type;
    _data['message'] = lastMessage;
    _data['update_data'] = lastMessageTime;
    _data['block_status'] = blockStatus;
    return _data;
  }
}