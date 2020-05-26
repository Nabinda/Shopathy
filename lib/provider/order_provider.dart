import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopathy/provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

//====adding cart items to order list=========
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = "https://shopathy.firebaseio.com/orders.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'title': cp.title,
                    })
                .toList(),
          }));
    } catch (error) {
      print(error.message);
      throw (error);
    }
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }

  //fetching orders from the database
  Future<void> fetchAndSetOrder() async {
    final url = "https://shopathy.firebaseio.com/orders.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<OrderItem> _loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      print(extractedData.toString());
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(OrderItem(
            id: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: double.parse(item['price'].toString()),
                    quantity: item['quantity'],
                    title: item['title']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
    } catch (error) {
      throw (error);
    }
  }
}
