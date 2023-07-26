import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:sizer/sizer.dart';

import '../../centralize_api.dart';
import '../../widgets/block_unblock.dart';
import '../controllers/block_info_controller.dart';
import '../model/blocked_info_model.dart';


class BlockedReportedUsersView extends StatelessWidget {
  const BlockedReportedUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blocked and Reported Users',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red.shade900,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Container(
                padding: EdgeInsets.all(5.sp),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  'Blocked Users',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(height: Get.height*0.4,child:
            GetBuilder<BlockReportController>(
              init: BlockReportController(),
              builder: (controller) {
                return BlockedReportedUserItem(dataList:controller.blockInfoModel.data ??[]);
              },),),
           /* Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return BlockedReportedUserItem(
                    userName: 'Blocked User $index',
                    reason: 'Blocked Reason $index',
                    isBlocked: true,
                  );
                },
              ),
            ),*/
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Container(
                padding: EdgeInsets.all(5.sp),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  'Reported Users',
                  style: TextStyle(
                    fontSize: 14.sp,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
           /* Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return BlockedReportedUserItem(
                    userName: 'Reported User $index',
                    reason: 'Reported Reason $index',
                    isBlocked: false,
                  );
                },
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

class BlockedReportedUserItem extends StatelessWidget {
  APIService apiService = APIService();
  BlockedReportedUserItem({
    required this.dataList,
    //required this.blockUnblock
  });

  final List<Data> dataList;
  //final Function blockUnblock;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        Data data = dataList[index];
        return GestureDetector(child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16.sp,
                    backgroundImage: NetworkImage(data.profilePicture??'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54'),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 3.sp,
                          child: CircleAvatar(
                            radius: 6.sp,
                            backgroundImage:
                            const NetworkImage("https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54"),
                            //const AssetImage('assets/images/indian_flag.png'),
                          ),
                        ),
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
                      /*Text(
                      'DUMMY TEXT',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: const Color(0xFF434343),
                      ),
                    ),
                    Text(
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
            Container(
              color: const Color(0xFFc4c4c4),
              height: 0.4.sp,
              width: MediaQuery.of(context).size.width * 0.73,
            ),
          ],
        ),
        onTap: (){
          BlockUnblock.showBlockedAlertDialog(context,data.userId??'', 'Unblock');

        },);

      },);
  }



}
