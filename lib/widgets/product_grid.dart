import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourite;
  ProductGrid(this.showFavourite);
  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(context);
    final products =
        showFavourite ? loadedProduct.favourites : loadedProduct.items;
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemCount: products.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ));
  }
}
