import 'package:get/get.dart';

import '../modules/home/home/bindings/home_binding.dart';
import '../modules/home/home/views/home_view.dart';
import '../modules/home/home/views/login.dart';
import '../modules/home/home/views/register.dart';
import '../modules/home/home/views/main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
