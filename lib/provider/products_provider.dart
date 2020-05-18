import 'package:flutter/material.dart';
import 'package:shopathy/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
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

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favourites {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  //this functions add new product
  void addProduct(Product product) {
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        price: product.price,
        description: product.description,
        imageURL: product.imageURL);

    _items.add(newProduct);
    notifyListeners();
  }

//this function updates the current product
  void updateProduct(String id, Product upProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = upProduct;
      notifyListeners();
    }
  }
}
