import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ChatScreenView extends StatefulWidget {
  const ChatScreenView({super.key});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: Color(0xFF3c03bc),
          leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            alignment: Alignment.centerLeft,
            enableFeedback: true,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
            iconSize: 16.sp,
          ),
          centerTitle: false,
          titleSpacing: 0.0,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.sp),
                child: Image.asset(
                  'assets/images/Image.png',
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.11,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 13.sp,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marc Stegen',
                    style:
                        TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Online',
                    style:
                        TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(22.sp),
              //     top: Radius.circular(22.sp),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ListView(
              children: [
                messageContainer(
                  text: 'How is the concept?',
                  isMe: true,
                  time: '09:54 PM',
                ),
                messageContainer(
                  text: 'Hows the concept? Hows the concept? Hows the concept?',
                  isMe: false,
                  time: '09:55 PM',
                ),
                messageContainer(
                  text: 'Hi',
                  isMe: false,
                  time: '09:58 PM',
                ),
                messageContainer(
                  text: 'Hello',
                  isMe: true,
                  time: '09:59 PM',
                ),
              ],
            )),
            Container(
              margin: EdgeInsets.all(
                18.sp,
              ),
              padding: EdgeInsets.only(left: 15.0.sp, right: 7.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    color: Color(0xFFf7aa07),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.sp, horizontal: 16.sp),
                        hintText: 'Type your message here',
                        hintStyle: TextStyle(
                            color: Color(0xffd4d3d5), fontSize: 12.sp),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.sp),
                          bottomLeft: Radius.circular(16.sp),
                          bottomRight: Radius.circular(16.sp),
                        ),
                        color: Color(0xFF3f02ca),
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.sp, vertical: 5.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageContainer extends StatelessWidget {
  messageContainer(
      {required this.text, required this.isMe, required this.time});

  String text;
  bool isMe;
  String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.sp),
        child: isMe == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.done_all,
                        color: Color(0xFF49d298),
                        size: 13.sp,
                      ),
                      SizedBox(
                        height: 2.sp,
                      ),
                      Text(
                        time,
                        style:
                            TextStyle(color: Color(0xffd4d3d5), fontSize: 9.sp),
                      )
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(16.sp),
                              bottomLeft: Radius.circular(16.sp),
                              bottomRight: Radius.circular(16.sp))
                          : BorderRadius.only(
                              topRight: Radius.circular(16.sp),
                              bottomLeft: Radius.circular(16.sp),
                              bottomRight: Radius.circular(16.sp)),
                      color: isMe ? Color(0xFFefeef0) : Color(0xFF49d298),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.sp,
                            color: isMe ? Color(0xFF85828a) : Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(16.sp),
                              bottomLeft: Radius.circular(16.sp),
                              bottomRight: Radius.circular(16.sp))
                          : BorderRadius.only(
                              topRight: Radius.circular(16.sp),
                              bottomLeft: Radius.circular(16.sp),
                              bottomRight: Radius.circular(16.sp)),
                      color: isMe ? Color(0xFFefeef0) : Color(0xFF49d298),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.sp,
                            color: isMe ? Color(0xFF85828a) : Colors.white),
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Color(0xffd4d3d5), fontSize: 9.sp),
                  ),
                ],
              ));
  }
}
