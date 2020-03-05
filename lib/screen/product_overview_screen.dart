//---------Initial Display Screen--------

import 'package:flutter/material.dart';
import 'package:shopathy/widgets/product_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopathy"),
        centerTitle: true,
      ),
      body: ProductGrid(),
    );
  }
}
