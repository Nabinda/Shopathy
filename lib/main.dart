import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/auth_provider.dart';
import 'package:shopathy/provider/cart_provider.dart';
import 'package:shopathy/provider/order_provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/screen/auth_screen.dart';
import 'package:shopathy/screen/cart_screen.dart';
import 'package:shopathy/screen/edit_product_screen.dart';
import 'package:shopathy/screen/order_screen.dart';
import 'package:shopathy/screen/product_detail_screen.dart';
import 'package:shopathy/screen/product_overview_screen.dart';
import 'package:shopathy/screen/splash_screen.dart';
import 'package:shopathy/screen/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update:
                (BuildContext context, Auth auth, Products previousProducts) {
              return Products(auth.token, auth.userId,
                  previousProducts == null ? [] : previousProducts.items);
            },
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (BuildContext context, Auth auth, Orders previousOrders) {
            return Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            );
          })
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Shopathy",
              theme: ThemeData(
                primaryColor: Colors.orange,
                accentColor: Colors.redAccent,
                fontFamily: "Nunito",
              ),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResult) =>
                          authResult.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
            );
          },
        ));
  }
}
