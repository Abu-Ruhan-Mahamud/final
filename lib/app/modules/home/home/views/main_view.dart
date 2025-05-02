import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'home_view.dart';

class MainView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    HomeView(),
    Center(
      child: Text(
        'No Notifications',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    ),
  ];

  final Color backgroundColor = Color(0xFF0D47A1);
  final Color selectedColor = Color(0xFFFF7043); // Orange
  final Color unselectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() => screens[selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -4),
              )
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: selectedIndex.value,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor.withOpacity(0.7),
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            onTap: (index) => selectedIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
