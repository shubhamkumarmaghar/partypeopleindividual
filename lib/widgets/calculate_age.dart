import 'dart:developer';

import 'package:intl/intl.dart';

class CalculateAge{

  static String calAge(String birthdate) {
    try {
      int age;
      if (birthdate == '' || birthdate.contains('0001')) {
        return "NA";
      }
      else {
        var d = birthdate.split('/');

        if(d[0]!=birthdate){
          birthdate = '${d[2]}-${d[1]}-${d[0]}';
        }
        else{
        birthdate;
        }

        DateTime birthDate = DateTime.parse(birthdate);

      //  String date =  DateFormat('yyyy-MM-dd').format(birthDate);


       // log('new date   ${birthDate.year.toString()}');
       //  birthDate = DateTime.parse(date);
        log('dategggg ${birthDate.year}');
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