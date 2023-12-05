import 'package:daxno_task/constants/colors.dart';
import 'package:daxno_task/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    return Scaffold(
      extendBody: true,
      body: Obx(() => controller.screen[controller.currentIndex.value]),
      floatingActionButton: ClipOval(
        child: Obx(
          () => FloatingActionButton(
            backgroundColor: prussianBlue,
            child: Icon(
              Icons.add,
              color:
                  controller.currentIndex.value == 4 ? greenColor : greyColor,
              size: 30,
            ),
            onPressed: () {
              controller.currentIndex.value = 4;
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          elevation: 0,
          color: prussianBlue,
          height: 65,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  controller.currentIndex.value = 0;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: controller.currentIndex.value == 0
                          ? greenColor
                          : greyColor,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                          fontSize: 12,
                          color: controller.currentIndex.value == 0
                              ? greenColor
                              : greyColor),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  controller.currentIndex.value = 1;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: controller.currentIndex.value == 1
                          ? greenColor
                          : greyColor,
                    ),
                    Text(
                      "State",
                      style: TextStyle(
                          fontSize: 12,
                          color: controller.currentIndex.value == 1
                              ? greenColor
                              : greyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  controller.currentIndex.value = 2;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pages,
                      color: controller.currentIndex.value == 2
                          ? greenColor
                          : greyColor,
                    ),
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 12,
                          color: controller.currentIndex.value == 2
                              ? greenColor
                              : greyColor),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  controller.currentIndex.value = 3;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_box,
                      color: controller.currentIndex.value == 3
                          ? greenColor
                          : greyColor,
                    ),
                    Text(
                      "More",
                      style: TextStyle(
                          fontSize: 12,
                          color: controller.currentIndex.value == 3
                              ? greenColor
                              : greyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
