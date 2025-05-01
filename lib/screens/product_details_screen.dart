import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final double productPrice;

  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.productImage, height: 250, width: 250),
            const SizedBox(height: 16),
            Text(
              widget.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.productPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Quantity: '),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Stock Available: 50', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logic to add to cart
              },
              child: const Text('Add to Cart'),
            ),
            const SizedBox(height: 16),
            const Text('Other Products in the Same Sport:',
                style: TextStyle(fontSize: 16)),
            // Example of suggesting other products
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ProductSuggestionCard(productName: 'Basketball 1', price: 30.0),
                ProductSuggestionCard(productName: 'Basketball 2', price: 35.0),
                ProductSuggestionCard(productName: 'Basketball 3', price: 40.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSuggestionCard extends StatelessWidget {
  final String productName;
  final double price;

  const ProductSuggestionCard({
    super.key,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network('https://via.placeholder.com/150',
                height: 80, width: 80),
            const SizedBox(height: 8),
            Text(productName),
            const SizedBox(height: 4),
            Text('\$$price', style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
