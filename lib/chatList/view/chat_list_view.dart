import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/chatScreen/controllers/chat_screen_controller.dart';
import 'package:sizer/sizer.dart';

import '../../chatScreen/model/chat_model.dart';
import '../../chatScreen/views/chat_screen_view.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: GetBuilder<ChatScreenController>(init: ChatScreenController(),
      builder: (controller){
        return Scaffold(
          appBar:  AppBar(
          flexibleSpace: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
          //   Colors.pink,
          // Colors.red.shade900
          Colors.red.shade800,
          Color(0xff7e160a),
          Color(0xff2e0303),
          ],
          // begin: Alignment.topCenter,
          //  end: Alignment.bottomCenter,


        ),
        ),
        ),
            elevation: 0,
            title: Text(
              "Chats",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body:
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    //   Colors.pink,
                    // Colors.red.shade900
                    Colors.red.shade800,
                    Color(0xff7e160a),
                    Color(0xff2e0303),
                  ],
                  // begin: Alignment.topCenter,
                  //  end: Alignment.bottomCenter,
                ),
              ),
              height: Get.height,
              width:Get.width,
              child: controller.isApiLoading == false? ListView.builder(
              itemCount: controller.chatList.length,
              itemBuilder: (context, index) {
                var data = controller.chatList[index];
                return GestureDetector(
                  onTap: (){
                    if(data.blockStatus =='Block')
                      {
                        Get.snackbar('Blocked User', 'User is Blocked ,Please Unblock First');
                      }
                    else{
                    Get.to(()=>ChatScreenView(id: data.id.toString()),arguments:data.id )?.
                    then((value) async {
                       await controller.getChatList();
                    });
                    }
                  },
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left:15.sp,right: 15.sp,top: 10.sp),
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,),
                        child: Row(
                          children: [
                            FittedBox(
                              child: Stack(
                                children: [
                                  Container(
                                    width: Get.width * 0.151,
                                    height: Get.width * 0.151,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: Get.width * 0.005,
                                        color: const Color(0xFFe3661d),
                                      ),
                                      borderRadius: BorderRadius.circular(100.sp), //<-- SEE HERE
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(Get.width * 0.006),
                                      child: CircleAvatar(
                                        // backgroundImage: NetworkImage(imageURL),
                                        backgroundImage:
                                        NetworkImage(data.profilePic),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: Get.width * 0.01,
                                    right: Get.width * 0.001,
                                    child: Container(
                                      width: Get.height * 0.019,
                                      height: Get.height * 0.019,
                                      // color: Colors.white,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFe3661d),
                                        borderRadius: BorderRadius.circular(100.sp),
                                      ),
                                      child: Icon(
                                        Icons.circle,
                                        color: data.onlineStatus=='on' ?Colors.green :Colors.red.shade900,
                                        size: Get.height * 0.016,
                                      ),
                                    )

                                  ),
                                  /*    Positioned(
                                bottom: 3.sp,
                                child: CircleAvatar(
                                  radius: 6.sp,
                                  backgroundImage:
                                  const NetworkImage("https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54"),
                                  //const AssetImage('assets/images/indian_flag.png'),
                                ),
                              ), */
                                ],
                              ),
                            ),
                            SizedBox(width: 12.sp),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.username ??'',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF434343),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: controller.getLastMessage(data.username),
                                  builder: (context, snapshot) {

                                    final data = snapshot.data?.docs;
                                    final list =
                                        data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                                    if (list.isNotEmpty){ _message = list[0];
                                    }
                                    return Row(
                                      children: [_message?.fromId == controller.myUsername.toString()?
                                        _message?.read == ''?Icon(
                                    Icons.done_all,
                                      color: Colors.grey,
                                      size: 13.sp,
                                    ):Icon(
                                    Icons.done_all,
                                    color: Color(0xFF49d298),
                                    size: 13.sp,
                                    ):Container(),
                                        Text(
                                          _message != null
                                              ?  ' ${_message!.msg}'
                                              : "",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color(0xFF434343),
                                            fontWeight: _message?.fromId == controller.myUsername.toString()?  FontWeight.normal :FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                                /* Text(
                          "profilepic",
                          style: TextStyle(
                              fontSize: 8.sp, color: const Color(0xFFc4c4c4)),
                        ),
                        */
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.width*0.001,)
                      /*   Container(
                color: const Color(0xFFc4c4c4),
                height: 0.4.sp,
                width: MediaQuery.of(context).size.width * 0.73,
              ),*/
                    ],
                  ),
                );
              },)
                :Center(child: CircularProgressIndicator()) ,),
       );
      }),
    );
  }
}
