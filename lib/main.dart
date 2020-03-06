import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/cart_provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/screen/product_detail_screen.dart';
import 'package:shopathy/screen/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Shopathy",
        theme: ThemeData(
          primaryColor: Colors.orange,
          accentColor: Colors.redAccent,
          fontFamily: "Nunito",
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
