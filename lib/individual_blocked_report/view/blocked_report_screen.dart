import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lottie/lottie.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/block_unblock.dart';
import '../controllers/block_info_controller.dart';
import '../model/blocked_info_model.dart';


class BlockedReportedUsersView extends StatelessWidget {
  const BlockedReportedUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        shape: Border(
          bottom: BorderSide(color: const Color(0xFFc4c4c4), width: 1.sp),
        ),
        backgroundColor: Colors.transparent,
        // Set the background color to transparent
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 18.sp),
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
          iconSize: 12.sp,
        ),
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          'Blocked User',
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.red.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          /*  Padding(
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
            ),  */
            Container(height: Get.height*0.4,child:
            GetBuilder<BlockReportController>(
              init: BlockReportController(),
              builder: (controller) {
                return controller.blockInfoModel.data != null ?
                BlockedReportedUserItem(dataList:controller.blockInfoModel.data ??[])
                :loder();
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
            ),

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
           */
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
  Widget loder()
  {return Center(
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Lottie.network(
              'https://assets-v2.lottiefiles.com/a/ebf552bc-1177-11ee-8524-57b09b2cd38d/PaP7jkQFk9.json')
        ]),
      )); }
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
            Container(
              padding: EdgeInsets.all(15.sp),
              color: Colors.white,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children:[CircleAvatar(
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
                        Text(
                          data.date ??'',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: const Color(0xFF434343),
                          ),
                        ),
                        /*  Text(
                      "profilepic",
                      style: TextStyle(
                          fontSize: 8.sp, color: const Color(0xFFc4c4c4)),
                    ),
                    */
                      ],
                    ),
                  ]),
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                      onPressed: () {
                        Alertdialogs.showBlockedAlertDialog(context,data.individualId??'', 'Unblock');
                      }, child: Text('Unblock'))
                ],
              ),
            ),
            Container(
              color: const Color(0xFFc4c4c4),
              height: 0.4.sp,
              width: MediaQuery.of(context).size.width ,
            ),
          ],
        ),
        onTap: (){
          Alertdialogs.showBlockedAlertDialog(context,data.individualId??'', 'Unblock');

        },);

      },);
  }



}
