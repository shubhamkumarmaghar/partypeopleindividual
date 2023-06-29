import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/individualDashboard/bindings/individual_dashboard_binding.dart';
import 'package:partypeopleindividual/individualDashboard/views/individual_dashboard_view.dart';
import 'package:partypeopleindividual/splash_screen/view/splash_screen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialBinding: IndividualDashboardBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Party People',
        theme: ThemeData.light(useMaterial3: false).copyWith(
          scaffoldBackgroundColor: Colors.red.shade900,
          primaryColor: Colors.red.shade900,
          appBarTheme: AppBarTheme(

            backgroundColor: Colors.red.shade900,
            titleTextStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.normal,
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Poppins',
            ),
            // Add more text styles as needed
          ),
        ),
        home: const IndividualDashboardView(),
      );
    });
  }
}
