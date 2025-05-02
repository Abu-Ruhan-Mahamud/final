import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  RxList<Map<String, dynamic>> carts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCarts();
  }

  Future<void> fetchCarts() async {
    try {
      final url = Uri.parse('https://fakestoreapi.com/carts');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        carts.value = List<Map<String, dynamic>>.from(data);
      } else {
        Get.snackbar('Error', 'Failed to load carts');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch carts');
    }
  }
}
