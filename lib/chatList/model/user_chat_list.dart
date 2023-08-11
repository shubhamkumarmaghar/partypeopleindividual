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
  });
  late final String id;
  late final String username;
  late final String onlineStatus;
  late final String createdAt;
  late final String profilePic;
  late final dynamic displayName;
  late final String displayStatus;
  late final String type;
  late final dynamic lastMessage;
  late final dynamic lastMessageTime;


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
    return _data;
  }
}