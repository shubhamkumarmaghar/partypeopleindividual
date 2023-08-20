import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/chatList/model/user_chat_list.dart';



class ChatListController extends GetxController{

  List<ChatUserListModel>  chatList = [];
  var isApiLoading = false;

  @override
  void onInit(){
    super.onInit();
    getChatList();


  }
  // get chatList

  Future<void> getChatList() async {
    try {
      isApiLoading = true;
      http.Response response = await http.post(
        Uri.parse('https://app.partypeople.in/v1/chat/get_chat_user_list_data'),
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        if (decode['message'] == 'user data found') {
          log('chat list $decode');
          final List<dynamic> chatuserlist = decode['data'] as List;
          chatList =
              chatuserlist.map((e) => ChatUserListModel.fromJson(e)).toList();
          isApiLoading = false;
          update();
        }
        else {
          log('No user data found');
          isApiLoading = false;
          update();
        }
      }
      else {
        log('user is not added to chat list , response is not 200 ');
      }
    }
    catch(e){
      log('found error $e');
    }
  }

}