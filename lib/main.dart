// ignore_for_file: prefer_const_constructors

import 'package:daxno_task/constants/colors.dart';
import 'package:daxno_task/screens/home_screen/home.dart';
import 'package:daxno_task/screens/pin_code_screen/pin_code_screen.dart';
import 'package:daxno_task/widgets/circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'utils/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDatabase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(
        'pin and frofile name ${DatabaseHelper().getPinCode()} : ${DatabaseHelper().getProfileName()}');
    return FutureBuilder(
        future: DatabaseHelper().isPinSet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final bool isPinSet = snapshot.data ?? false;

            return GetMaterialApp(
              title: 'Asset Flow',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: darkPrussianBlue,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: isPinSet ? PinCodeScreen() : const Home(),
            );
          }
        });
  }
}
