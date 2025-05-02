import 'package:flutter/material.dart';

class ProductNameText extends StatelessWidget {
  final String name;
  const ProductNameText({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}
