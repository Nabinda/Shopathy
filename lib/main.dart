import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/cart_provider.dart';
import 'package:shopathy/provider/order_provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/screen/cart_screen.dart';
import 'package:shopathy/screen/edit_product_screen.dart';
import 'package:shopathy/screen/order_screen.dart';
import 'package:shopathy/screen/product_detail_screen.dart';
import 'package:shopathy/screen/product_overview_screen.dart';
import 'package:shopathy/screen/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Shopathy",
        theme: ThemeData(
          primaryColor: Colors.orange,
          accentColor: Colors.redAccent,
          fontFamily: "Nunito",
        ),
        initialRoute: "/",
        routes: {
          "/": (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
