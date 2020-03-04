//---------Initial Display Screen--------

import 'package:flutter/material.dart';
import 'package:shopathy/models/product.dart';
import 'package:shopathy/widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProduct = [
    Product(
        id: "1",
        title: "Watch",
        price: 200,
        description: "The best watch that fits both classy and modern look",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71vKyimxsiL._UX569_.jpg",
        isFavourite: false),
    Product(
        id: "2",
        title: "Car",
        price: 200000,
        description: "Safest and Fastest Car",
        imageURL:
            "https://c.ndtvimg.com/2019-12/124adp6o_mclaren-620r_625x300_10_December_19.jpg",
        isFavourite: false),
    Product(
        id: "3",
        title: "Shoes",
        price: 1000,
        description: "Best Sport Shoes",
        imageURL:
            "https://static.zumiez.com/skin/frontend/delorum/default/images/champion-rally-pro-shoes-feb19-444x500.jpg",
        isFavourite: false),
    Product(
        id: "4",
        title: "Laptop",
        price: 250000,
        description: "Best Laptop for Gaming and Animation",
        imageURL:
            "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/ha5/h7f/9176281251870/razer-blade-15-usp01-mobile-gaming-laptop-v1.jpg",
        isFavourite: false),
    Product(
        id: "5",
        title: "TV",
        price: 25000,
        description: "4K Curved Display",
        imageURL:
            "https://www.starmac.co.ke/wp-content/uploads/2019/08/samsung-65-inch-ultra-4k-curved-tv-ua65ku7350k-series-7.jpg",
        isFavourite: false)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopathy"),
        centerTitle: true,
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2),
          itemCount: loadedProduct.length,
          itemBuilder: (ctx, index) => ProductItem(
                id: loadedProduct[index].id,
                title: loadedProduct[index].title,
                imageUrl: loadedProduct[index].imageURL,
              )),
    );
  }
}
