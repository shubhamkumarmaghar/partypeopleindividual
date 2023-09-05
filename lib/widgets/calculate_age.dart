import 'dart:developer';

import 'package:intl/intl.dart';

class CalculateAge{

  static String calAge(String birthdate) {
    try {
      int age;
      if (birthdate == '') {
        return "NA";
      }
      else {
        DateTime birthDate = DateTime.parse(birthdate);
        String date =  DateFormat('yyyy-MM-dd').format(birthDate);
        log('date   ${date.split(' ')[0]}');
       // log('new date   ${birthDate.year.toString()}');
         birthDate = DateTime.parse(date);
       // log('new date   $birth');
        DateTime currentDate = DateTime.now();
        age = currentDate.year - birthDate.year;
        int month1 = currentDate.month;
        int month2 = birthDate.month;
        if (month2 > month1) {
          age--;
        } else if (month1 == month2) {
          int day1 = currentDate.day;
          int day2 = birthDate.day;
          if (day2 > day1) {
            age--;
          }
        }
      }
      log("$age");
      return age.toString()+ ' Years';
    }
    catch(e)
    {
      log('gchjvhvhk ${e}');
      return "NA";
    }

  }

}