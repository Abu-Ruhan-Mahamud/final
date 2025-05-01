import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Basketball',
      'price': 30.0,
      'quantity': 2,
    },
    {
      'name': 'Soccer Ball',
      'price': 25.0,
      'quantity': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double total = 0;
    cartItems.forEach((item) {
      total += item['price'] * item['quantity'];
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            leading: Image.network('https://via.placeholder.com/150',
                width: 50, height: 50),
            title: Text(item['name']),
            subtitle: Text('Quantity: ${item['quantity']}'),
            trailing: Text(
                '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Proceed to payment
                },
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
