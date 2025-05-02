import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartView extends StatefulWidget {
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  bool isLoading = true;

  final Color primaryColor = Color(0xFF0D47A1);
  final Color accentColor = Color(0xFFFF7043);

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final cartUrl = Uri.parse('https://fakestoreapi.com/carts');
      final cartResponse = await http.get(cartUrl);

      if (cartResponse.statusCode == 200) {
        List<dynamic> carts = jsonDecode(cartResponse.body);
        List<Map<String, dynamic>> productsInCart = [];

        for (var cart in carts.take(5)) {
          for (var product in cart['products']) {
            int productId = product['productId'];
            int quantity = product['quantity'];

            final productUrl =
                Uri.parse('https://fakestoreapi.com/products/$productId');
            final productResponse = await http.get(productUrl);

            if (productResponse.statusCode == 200) {
              var productData = jsonDecode(productResponse.body);

              productsInCart.add({
                "id": productId,
                "title": productData['title'],
                "price": (productData['price'] as num).toDouble(),
                "image": productData['image'],
                "quantity": quantity,
              });
            }
          }
        }

        cartItems.value = productsInCart;
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load cart data');
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  void increaseQuantity(int index) {
    cartItems[index]['quantity']++;
    cartItems.refresh();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index]['quantity'] > 0) {
      cartItems[index]['quantity']--;
      cartItems.refresh();
    }
  }

  double calculateTotalForProduct(int index) {
    double price = (cartItems[index]['price'] as num).toDouble();
    double quantity = (cartItems[index]['quantity'] as num).toDouble();
    return price * quantity;
  }

  double calculateGrandTotal() {
    double total = 0;
    for (var item in cartItems) {
      double price = (item['price'] as num).toDouble();
      double quantity = (item['quantity'] as num).toDouble();
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Cart'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Obx(() {
              if (cartItems.isEmpty) {
                return Center(child: Text('No items in cart'));
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                                Get.defaultDialog(
                                  title: item['title'],
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(item['image'], height: 100),
                                      SizedBox(height: 10),
                                      Text("Price: \$${item['price']}"),
                                      Text("Quantity: ${item['quantity']}"),
                                      Text(
                                          "Total: \$${calculateTotalForProduct(index).toStringAsFixed(2)}"),
                                    ],
                                  ),
                                );
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                item['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => decreaseQuantity(index),
                                    icon: Icon(Icons.remove_circle_outline),
                                    color: primaryColor,
                                  ),
                                  Text("${item['quantity']}"),
                                  IconButton(
                                    onPressed: () => increaseQuantity(index),
                                    icon: Icon(Icons.add_circle_outline),
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "\$${calculateTotalForProduct(index).toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(() => Text(
                                "\$${calculateGrandTotal().toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
    );
  }
}
