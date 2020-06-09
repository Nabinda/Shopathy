import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/helper/custom_route.dart';
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
import 'package:shopathy/screen/user_product_screen.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

void main() => runApp(SplashClass());

class SplashClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update:
                (BuildContext context, Auth auth, Products previousProducts) {
              return Products(auth.token, auth.userId,
                  previousProducts == null ? [] : previousProducts.items);
            },
          ),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (BuildContext context, Auth auth, Orders previousOrders) {
            return Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            );
          })
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Shopathy",
          theme: ThemeData(
              primaryColor: Colors.orange,
              accentColor: Colors.redAccent,
              fontFamily: "Nunito",
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: SplashBetween(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ));
  }
}

class SplashBetween extends StatefulWidget {
  @override
  _SplashBetweenState createState() => _SplashBetweenState();
}

class _SplashBetweenState extends State<SplashBetween> {
  bool isInit = true;
  bool isLogin = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      checkLogin();
    }
    isInit = false;
  }

  void checkLogin() async {
    isLogin = await Provider.of<Auth>(context).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen.navigate(
        name: "assets/images/splash.flr",
        fit: BoxFit.cover,
        transitionsBuilder: (ctx, animation, second, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        backgroundColor: Colors.blueGrey,
        startAnimation: "Untitled",
        loopAnimation: "Untitled",
        until: () => Future.delayed(Duration(seconds: 3)),
        alignment: Alignment.center,
        next: (_) => isLogin ? ProductOverviewScreen() : AuthScreen(),
      ),
    );
  }
}
