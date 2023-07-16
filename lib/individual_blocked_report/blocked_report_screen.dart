import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
                  color: Colors.yellow.shade400,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  'Blocked Users',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
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
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}

class BlockedReportedUserItem extends StatelessWidget {
  const BlockedReportedUserItem({
    required this.userName,
    required this.reason,
    required this.isBlocked,
  });

  final String userName;
  final String reason;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.sp,
        backgroundColor: isBlocked ? Colors.red : Colors.blue,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        userName,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        reason,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.grey,
        ),
      ),
    );
  }
}
