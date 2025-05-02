import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Logger
  final Logger _logger = Logger();

  // Text Controllers for Login/Register
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passtextEditingController = TextEditingController();

  // Counter Example
  RxInt counterValue = 0.obs;

  // API Data
  RxList<String> categories = <String>[].obs;
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  // Selected Category ID
  RxString selectedCategory = ''.obs;

  // ✅ Reactive selected category map
  RxMap<String, dynamic> selectedCategoryProduct = <String, dynamic>{}.obs;

  // Track current Firebase user
  Rxn<User> currentUser = Rxn<User>();

  // Dummy category list (static)
  final List<Map<String, dynamic>> dummyCategoryList = [
    {
      "id": "electronics",
      "name": "Electronics",
      "imageUrl": "https://example.com/electronics.jpg"
    },
    {
      "id": "jewelery",
      "name": "Jewelery",
      "imageUrl": "https://example.com/jewelery.jpg"
    },
    {
      "id": "men's clothing",
      "name": "Men's clothing",
      "imageUrl": "https://example.com/men.jpg"
    },
    {
      "id": "women's clothing",
      "name": "Women's clothing",
      "imageUrl": "https://example.com/women.jpg"
    },
  ];

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    fetchCategories();
    fetchProducts();
  }

  @override
  void onClose() {
    emailtextEditingController.dispose();
    passtextEditingController.dispose();
    super.onClose();
  }

  // Counter Logic
  void mIncrementalMethod() => counterValue.value++;
  void mDecrementalMethod() => counterValue.value--;

  // Firebase Login
  Future<void> mLogin() async {
    try {
      if (emailtextEditingController.text.trim().isEmpty ||
          passtextEditingController.text.trim().isEmpty) {
        Get.snackbar("Error", "Email and password cannot be empty");
        return;
      }

      UserCredential response = await _auth.signInWithEmailAndPassword(
        email: emailtextEditingController.text.trim(),
        password: passtextEditingController.text.trim(),
      );

      currentUser.value = response.user;
      _logger.i("Login successful: ${response.user?.email}");

      emailtextEditingController.clear();
      passtextEditingController.clear();
      Get.offAllNamed('/');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Unknown error occurred");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Firebase Register
  Future<void> mRegister({required String email, required String pass}) async {
    try {
      if (email.isEmpty || pass.isEmpty) {
        Get.snackbar("Error", "Email and password cannot be empty");
        return;
      }

      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      Get.snackbar("Success", "Account created successfully");

      emailtextEditingController.clear();
      passtextEditingController.clear();
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registration Error", e.message ?? "Unknown error occurred");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Firebase Logout
  Future<void> mLogout() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
      Get.snackbar("Success", "Signed Out Successfully");

      Get.delete<HomeController>();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Fetch All Categories
  Future<void> fetchCategories() async {
    try {
      final url = Uri.parse('https://fakestoreapi.com/products/categories');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        categories.value = List<String>.from(data);
        _logger.i("Categories fetched: ${categories.length}");
      } else {
        Get.snackbar('Error', 'Failed to load categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
      _logger.e(e.toString());
    }
  }

  // Fetch All Products
  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse('https://fakestoreapi.com/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        products.value = List<Map<String, dynamic>>.from(data);
        _logger.i("Products fetched: ${products.length}");
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
      _logger.e(e.toString());
    }
  }

  // Fetch Products by Selected Category
  Future<void> fetchCategoryProductsFromMap(
      Map<String, dynamic> categoryMap) async {
    try {
      // ✅ Safe reactive update
      if (categoryMap["id"] != null) {
        selectedCategoryProduct.value = categoryMap;
      }

      String categoryId = categoryMap["id"];
      final url =
          Uri.parse("https://fakestoreapi.com/products/category/$categoryId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        products.value = List<Map<String, dynamic>>.from(data);
        _logger.i(
            "Products for category '$categoryId' fetched: ${products.length}");
      } else {
        Get.snackbar('Error', 'Failed to load products for category');
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products by category");
      _logger.e(e.toString());
    }
  }

  // Optional: Select category string id
  void selectCategory(String category) {
    selectedCategory.value = category;
    _logger.i("Selected Category: $category");
  }
}
