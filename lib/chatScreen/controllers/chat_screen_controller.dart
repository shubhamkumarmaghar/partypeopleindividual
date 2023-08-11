import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../model/chat_model.dart';
import '../model/user_model.dart';


class ChatScreenController  extends GetxController{
  GetUserModel? getUserModel;
  var isApiLoading = false;
  String? userId;
  String myUsername ="";


  @override
  void onInit(){
    super.onInit();
    userId = Get.arguments as String;
    myUsername= GetStorage().read('my_user_id');
    getChatUserData();


  }
  // for authentication
//  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for getting current mate data

  Future<void> getChatUserData() async {
    isApiLoading = true;

    try {
      http.Response response = await http.post(
        Uri.parse('http://app.partypeople.in/v1/account/get_single_user'),
        body: {'user_id': userId},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print(decodedData);
       getUserModel = GetUserModel.fromJson(decodedData);
        addChatUserToList();
      }
      isApiLoading = false;
      update();
    } catch (e) {
      print('Error fetching user: $userId ---- $e');
      update();
    }
  }
// for adding user to chat list
 Future<void> addChatUserToList() async
 {
   try{
    http.Response response = await http.post(Uri.parse('http://app.partypeople.in/v1/chat/add_chat'),
       body: {'individual_user_id': userId } ,
       headers: {'x-access-token' : '${GetStorage().read('token')}'}
    );
    if(response.statusCode == 200){
      if(jsonDecode(response.body)['message'] == 'Chat Create Successfully.'){
        log('user added to chat list successsfuly');
        update();
      }
      else{
        log('user is not added to chat list ');
        update();
      }
      }
    else{
      log('user is not added to chat list , response is not 200 ');
    }

 }
   catch(e)
   {
     log('error found  $e');
   }
 }
 

  // for storing self information
  /*static ChatUser me = ChatUser(
  id: user.uid,
  name: user.displayName.toString(),
  email: user.email.toString(),
  about: "Hey, I'm using We Chat!",
  image: user.photoURL.toString(),
  createdAt: '',
  isOnline: false,
  lastActive: '',
  pushToken: '');
*/



  // to return current user
  //static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token

  static Future<void> getFirebaseMessagingToken() async {
  await fMessaging.requestPermission();

  await fMessaging.getToken().then((t) {
  if (t != null) {
  //me.pushToken = t;
  log('Push Token: $t');
  }
  });

  // for handling foreground messages
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
     }
   });
  }

  // for sending push notification
  Future<void> sendPushNotification(
  GetUserModel chatUser, String msg) async {
  try {
  final body = {
  "to": chatUser.data?.deviceToken,
  "notification": {
  "title": myUsername, //our name should be send
  "body": msg,
  "android_channel_id": "chats"
  },
  // "data": {
  //   "some_data": "User ID: ${me.id}",
  // },
  };

  var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  headers: {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader:
  'key=AAAA8XNSH0I:APA91bE4_3dlb09VoZdl3ZEf3qUIGjWoJY8nybtqvyZLmfBEQVfkh0C1aN_93cmMDGbt2Fkz-6T_j7GhMHngNnwgCU2JJM3RB42-zzEoUlGLTQFlkJKPy-VvaekPdufFsYypPLfJxqnx'
  },
  body: jsonEncode(body));
  log('Response status: ${res.statusCode}');
  log('Response body: ${res.body}');
  } catch (e) {
  log('\nsendPushNotificationE: $e');
  }
  }




  // for checking if user exists or not?
 /* static Future<bool> userExists() async {
  return (await firestore.collection('users').doc(user.uid).get()).exists;
  }
  */

  // for adding an chat user for our conversation
 /* Future<bool> addChatUser(String unique_id) async {
  final data = await firestore
      .collection('users')
      .where('uniqueId', isEqualTo: unique_id)
      .get();

  log('data: ${data.docs}');

  if (data.docs.isNotEmpty && data.docs.first.id != getUserModel?.data?.uniqueId) {
  //user exists

  log('user exists: ${data.docs.first.data()}');

  firestore
      .collection('users')
      .doc(getUserModel?.data?.uniqueId)
      .collection('my_users')
      .doc(data.docs.first.id)
      .set({});

  return true;
  } else {
  //user doesn't exists

  return false;
  }
  }
*/

  // for getting current user info
 /* static Future<void> getSelfInfo() async {
  await firestore.collection('users').doc(user.uid).get().then((user) async {
  if (user.exists) {
  me = ChatUser.fromJson(user.data()!);
  await getFirebaseMessagingToken();

  //for setting user status to active
  APIs.updateActiveStatus(true);
  log('My Data: ${user.data()}');
  } else {
  await createUser().then((value) => getSelfInfo());
  }
  });
  }
*/

  // for creating a new user
  /* static Future<void> createUser() async {
  final time = DateTime.now().millisecondsSinceEpoch.toString();

  final chatUser = ChatUser(
  id: user.uid,
  name: user.displayName.toString(),
  email: user.email.toString(),
  about: "Hey, I'm using We Chat!",
  image: user.photoURL.toString(),
  createdAt: time,
  isOnline: false,
  lastActive: time,
  pushToken: '');

  return await firestore
      .collection('users')
      .doc(user.uid)
      .set(chatUser.toJson());
  }
  */

  // for getting id's of known users from firestore database
 /* static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
  return firestore
      .collection('users')
      .doc(user.uid)
      .collection('my_users')
      .snapshots();
  }
  */

  // for getting all users from firestore database
/*  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
  List<String> userIds) {
  log('\nUserIds: $userIds');

  return firestore
      .collection('users')
      .where('id',
  whereIn: userIds.isEmpty
  ? ['']
      : userIds) //because empty list throws an error
  // .where('id', isNotEqualTo: user.uid)
      .snapshots();
  }
  */

  // for adding an user to my user when first message is send
  Future<void> sendFirstMessage(
      GetUserModel chatUser, String msg, Type type) async {
  await firestore
      .collection('users')
      .doc(chatUser.data?.uniqueId)
      .collection('my_users')
      .doc(chatUser.data?.id)
      .set({}).then((value) => sendMessage(chatUser, msg, type));
  }


  // for updating user information
 /* static Future<void> updateUserInfo() async {
  await firestore.collection('users').doc(user.uid).update({
  'name': me.name,
  'about': me.about,
  });
  }


  */

  // update profile picture of user
  /* static Future<void> updateProfilePicture(File file) async {
  //getting image file extension
  final ext = file.path.split('.').last;
  log('Extension: $ext');

  //storage file ref with path
  final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

  //uploading image
  await ref
      .putFile(file, SettableMetadata(contentType: 'image/$ext'))
      .then((p0) {
  log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  });

  //updating image in firestore database
  me.image = await ref.getDownloadURL();
  await firestore
      .collection('users')
      .doc(user.uid)
      .update({'image': me.image});
  }
*/

  // for getting specific user info
 /* static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
  ChatUser chatUser) {
  return firestore
      .collection('users')
      .where('id', isEqualTo: chatUser.id)
      .snapshots();
  }
*/

  // update online or last active status of user
 /* static Future<void> updateActiveStatus(bool isOnline) async {
  firestore.collection('users').doc(user.uid).update({
  'is_online': isOnline,
  'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
  'push_token': me.pushToken,
  });
  }
*/
  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  String getConversationID(String id) => myUsername.hashCode <= id.hashCode
  ? '${myUsername}_$id'
      : '${id}_${myUsername}';

  // for getting all messages of a specific conversation from firestore database
   Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
  GetUserModel? user) {
  return firestore
      .collection('chats/${getConversationID(user?.data?.username??'')}/messages/')
      .orderBy('sent', descending: true)
      .snapshots();
  }



  // for sending message
  Future<void> sendMessage(
  GetUserModel? chatUser, String msg, Type type) async {
  //message sending time (also used as id)
  final time = DateTime.now().millisecondsSinceEpoch.toString();

  //message to send
  final Message message = Message(
  toId: chatUser?.data?.username??"",
  msg: msg,
  read: '',
  type: type,
  fromId: GetStorage().read("my_user_id"),
      sent: time,
      fcmToken: chatUser?.data?.deviceToken ??'');
  final ref = firestore
      .collection('chats/${getConversationID(chatUser?.data?.username ??'')}/messages/');
  await ref.doc(time).set(message.toJson()).then((value) => sendPushNotification(chatUser!, type == Type.text ? msg : 'image'));
  }


  //update read status of message
  Future<void> updateMessageReadStatus(Message message) async {
     try {
       if(message.fromId != myUsername) {
         firestore
             .collection(
             'chats/${getConversationID(message.fromId)}/messages/')
             .doc(message.sent)
             .update({'read': DateTime
             .now()
             .millisecondsSinceEpoch
             .toString()});
         log(' another user read the message');
       }
       else{
         log('another user is not seen message yet');
       }
      /* firestore
          .collection('chats')
          .doc('${getConversationID(message.fromId)}')
          .get().then((DocumentSnapshot snapshot) {
            if(snapshot.exists) {

            }
            else{
              log("another user not seen message yet");
            }
      }); */
     }
     catch(e)
    {
      log('failed to update status $e');
    }
  }


  //get only last message of a specific chat
   Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
       GetUserModel? user) {

  return firestore
      .collection('chats/${getConversationID(user?.data?.username??"")}/messages/')
      .orderBy('sent', descending: true)
      .limit(1)
      .snapshots();
  }

  //send chat image

   Future<void> sendChatImage(GetUserModel? chatUser, File file) async {
  //getting image file extension
  final ext = file.path.split('.').last;

  //storage file ref with path
  final ref = storage.ref().child(
  'images/${getConversationID(chatUser?.data?.id??'')}/${DateTime.now().millisecondsSinceEpoch}.$ext');

  //uploading image
  await ref
      .putFile(file, SettableMetadata(contentType: 'image/$ext'))
      .then((p0) {
  log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  });

  //updating image in firestore database
  final imageUrl = await ref.getDownloadURL();
  await sendMessage(chatUser, imageUrl, Type.image);
  }



  //delete message

  Future<void> deleteMessage(Message message) async {
  await firestore
      .collection('chats/${getConversationID(message.toId)}/messages/')
      .doc(message.sent)
      .delete();

  if (message.type == Type.image) {
  await storage.refFromURL(message.msg).delete();
  }
  }

  //update message

  Future<void> updateMessage(Message message, String updatedMsg) async {

    await firestore
      .collection('chats/${getConversationID(message.toId)}/messages/')
      .doc(message.sent)
      .update({'msg': updatedMsg});
  }



  @override
  void onClose() {
    var a = getLastMessage(getUserModel);
    log('dispose  $a');
    super.onClose();
  }
  }

