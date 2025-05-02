import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'product_view.dart';
import 'all_products_view.dart';
import 'cart_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final Color primaryColor = const Color(0xFF0D47A1);
  final Color backgroundColor = const Color(0xFFF9F9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'ShopOnline',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        // ✅ You missed wrapping everything in this Drawer widget
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to ShopOnline!',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore your needs with us',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list, color: primaryColor),
              title: Text('All Products'),
              onTap: () {
                Get.to(() => AllProductsView());
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: primaryColor),
              title: Text('Cart'),
              onTap: () {
                Get.to(() => CartView());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: Text('Logout'),
              onTap: () async {
                await controller.mLogout();
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.dummyCategoryList.length,
              itemBuilder: (context, index) {
                final category = controller.dummyCategoryList[index];
                final isSelected =
                    controller.selectedCategoryProduct.value["id"] ==
                        category["id"];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category["name"]),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    onSelected: (selected) async {
                      await controller.fetchCategoryProductsFromMap(category);
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.products.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => ProductDetailsView(product: product));
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  product['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "\$${product['price']}",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
