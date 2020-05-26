import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopathy/exception/http_exception.dart';
import 'package:shopathy/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//        id: "1",
//        title: "Watch",
//        price: 200,
//        description: "The best watch that fits both classy and modern look",
//        imageURL:
//            "https://images-na.ssl-images-amazon.com/images/I/71vKyimxsiL._UX569_.jpg",
//        isFavourite: false),
//    Product(
//        id: "2",
//        title: "Car",
//        price: 200000,
//        description: "Safest and Fastest Car",
//        imageURL:
//            "https://c.ndtvimg.com/2019-12/124adp6o_mclaren-620r_625x300_10_December_19.jpg",
//        isFavourite: false),
//    Product(
//        id: "3",
//        title: "Shoes",
//        price: 1000,
//        description: "Best Sport Shoes",
//        imageURL:
//            "https://static.zumiez.com/skin/frontend/delorum/default/images/champion-rally-pro-shoes-feb19-444x500.jpg",
//        isFavourite: false),
//    Product(
//        id: "4",
//        title: "Laptop",
//        price: 250000,
//        description: "Best Laptop for Gaming and Animation",
//        imageURL:
//            "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/ha5/h7f/9176281251870/razer-blade-15-usp01-mobile-gaming-laptop-v1.jpg",
//        isFavourite: false),
//    Product(
//        id: "5",
//        title: "TV",
//        price: 25000,
//        description: "4K Curved Display",
//        imageURL:
//            "https://www.starmac.co.ke/wp-content/uploads/2019/08/samsung-65-inch-ultra-4k-curved-tv-ua65ku7350k-series-7.jpg",
//        isFavourite: false)
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
  Future<void> addProduct(Product product) async {
    const url = "https://shopathy.firebaseio.com/products.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
            'isFavourite': product.isFavourite,
          }));
      //the future gives response after posting to the database

      print(json.decode(response.body)['name']);
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageURL: product.imageURL);

      _items.add(newProduct);
      notifyListeners();
    }
    //if any error occurs during post we catch and execute accordingly
    catch (error) {
      print(error);
      throw (error);
    }
  }

  //this function fetches the product from firebase
  Future<void> fetchAndSetProduct() async {
    const url = "https://shopathy.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: double.parse(prodData['price'].toString()),
            imageURL: prodData['imageURL'],
            isFavourite: prodData['isFavourite']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw (error);
    }
  }

//this function updates the current product
  Future<void> updateProduct(String id, Product upProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url = "https://shopathy.firebaseio.com/products/$id.json";
        await http.patch(url,
            body: json.encode({
              'title': upProduct.title,
              'price': upProduct.price,
              'description': upProduct.description,
              'imageURL': upProduct.imageURL,
              'isFavourite': upProduct.isFavourite,
            }));
        _items[prodIndex] = upProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

//this function deletes the product
  Future<void> deleteProduct(String id) async {
    final url = "https://shopathy.firebaseio.com/products/$id.json";
    final existingProductIndex = items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    try {
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException("Could not delete Product");
      } else {
        existingProduct = null;
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete Product");
    }
  }
}
